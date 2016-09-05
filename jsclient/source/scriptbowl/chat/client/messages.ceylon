import ceylon.json {
    JsonObject, parse,
    JsonArray
}
shared void doLoadMessages(XHR req)() {
    if (is JsonArray resp = parse(req.responseText)) {
        value sb = StringBuilder();
        for (jsm in resp) {
            if (is JsonObject m = jsm) {
                value ts = m.getInteger("t");
                sb.append("<p><b>").append(m.getString("from"))
                    .append(":</b> ").append(m.getString("m"))
                    .append(" <i>").append(ts.string).append("</i></p>");
                if (ts > client.lastTimestamp) {
                    client.lastTimestamp = ts;
                }
            }
        }
        if (sb.empty && client.lastTimestamp == 0) {
            dynamic {
                document.getElementById("chat").innerHTML =
                   "Nothing has been said yet. Start a conversation!";
            }
        } else {
            client.appendToChat(sb.string);
        }
    }
}

shared void loadMessages() {
    if (client.loggedIn) {
        xhr(client.urlMessages.replace("USER", client.token).replace("TS", "``client.lastTimestamp``"), doLoadMessages);
    }
}

shared void doSubmit(XHR req)() {
    if (is JsonObject resp = parse(req.responseText),
        is Integer ts = resp.get("t")) {
        String msg;
        dynamic {
            msg = document.getElementById("txt").\ivalue;
        }
        print("Submit OK: ``ts``");
        client.lastTimestamp = ts;
        value newMessage = "<p><b>``client.username``:</b> ``msg`` <i>``ts``</i></p>";
        client.appendToChat(newMessage);
        dynamic {
            document.getElementById("txt").\ivalue = "";
        }
    }
}

shared void submit() {
    if (client.loggedIn) {
        String txt;
        dynamic {
            txt = document.getElementById("txt").\ivalue;
        }
        String msg = txt.replace("/", "\\/");
        xhr(client.urlSubmit.replace("USER", client.token).replace("MSG", msg), doSubmit);
    }
}
