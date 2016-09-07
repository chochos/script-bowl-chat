import ceylon.json {
    JsonObject, parse,
    JsonArray
}
import ceylon.interop.browser { XMLHttpRequest }
import ceylon.interop.browser.dom { Event }

"This is called when the list of new messages is received."
void doLoadMessages(XMLHttpRequest req)(Event event) {
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

"This is called periodically, to load new messages from the server"
shared void loadMessages() {
    if (client.loggedIn) {
        xhr(client.urlMessages.replace("USER", encodeParam(client.token))
            .replace("TS", client.lastTimestamp.string), doLoadMessages);
    }
}

"This is called upon Ajax submit response"
void doSubmit(XMLHttpRequest req)(Event event) {
    if (is JsonObject resp = parse(req.responseText),
        is Integer ts = resp.get("t")) {
        String msg;
        dynamic {
            msg = document.getElementById("txt").\ivalue;
        }
        client.lastTimestamp = ts;
        value newMessage = "<p><b>``client.username``:</b> ``msg`` <i>``ts``</i></p>";
        client.appendToChat(newMessage);
        dynamic {
            document.getElementById("txt").\ivalue = "";
            document.getElementById("txt").focus();
        }
    }
}

"This method is called by the Send button, to add a message to the chat."
Boolean submit() {
    if (client.loggedIn) {
        String txt;
        dynamic {
            txt = document.getElementById("txt").\ivalue;
        }
        String msg = txt.replace("/", "\\/");
        xhr(client.urlSubmit.replace("USER", encodeParam(client.token))
            .replace("MSG", encodeParam(msg)), doSubmit);
    }
    return false;
}
