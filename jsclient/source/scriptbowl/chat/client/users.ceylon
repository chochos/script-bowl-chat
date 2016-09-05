import ceylon.json { JsonObject, parse,
    JsonArray }

shared void doLogin(XHR req)() {
    if (is JsonObject resp = parse(req.responseText)) {
        if (is String t = resp.get("token")) {
            client.token = t;
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

shared void login() {
    String uname;
    dynamic {
        uname = document.getElementById("login").\ivalue;
    }
    print("Login ``uname``");
    xhr(client.urlLogin.replace("USER", uname), doLogin);
}

shared void doListUsers(XHR req)() {
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

shared void listUsers() {
    if (client.loggedIn) {
        xhr(client.urlUsers.replace("USER", client.token), doListUsers);
    }
}