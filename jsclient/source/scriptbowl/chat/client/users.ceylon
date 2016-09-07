import ceylon.json { JsonObject, parse,
    JsonArray }
import ceylon.interop.browser { XMLHttpRequest }
import ceylon.interop.browser.dom { Event }

"The callback for the login response."
void doLogin(XMLHttpRequest req)(Event event) {
    if (is JsonObject resp = parse(req.responseText)) {
        if (is String t = resp.get("token")) {
            client.token = t;
            client.username = resp.getString("name");
            dynamic {
                setInterval(listUsers, 1000);
                setInterval(loadMessages, 1000);
                document.getElementById("myModal").style.display = "none";
            }
        } else {
            dynamic {
                alert("Something bad happened. Reload and retry.
                       ``req.responseText``");
            }
        }
    } else {
        dynamic {
            alert("Something bad happened. Reload and retry.
                   ``req.responseText``");
        }
    }
}

"Sends an async login request."
shared void login() {
    String uname;
    dynamic {
        uname = document.getElementById("login").\ivalue;
    }
    print("Login ``uname``");
    xhr(client.urlLogin.replace("USER", encodeParam(uname)), doLogin);
}

"The callback function for handling the user list response."
void doListUsers(XMLHttpRequest req)(Event event) {
    String html;
    if (is JsonArray users = parse(req.responseText)) {
        value sb = StringBuilder();
        for (u in users) {
            if (is JsonObject u) {
                sb.append("<div>")
                    .append((u.get("name") else "NAME?").string)
                    .append("</div>");
            }
        }
        if (sb.empty) {
            html = "You're the first user!";
        } else {
            html = sb.string;
        }
    } else {
        html = "Something bad happened.";
    }
    dynamic {
        document.getElementById("users").innerHTML = html;
    }
}

"This is called periodically to list the users connected to the chat."
shared void listUsers() {
    if (client.loggedIn) {
        xhr(client.urlUsers.replace("USER", encodeParam(client.token)), doListUsers);
    }
}
