import ceylon.json {
    JsonObject, parse,
    JsonArray
}
import ceylon.interop.browser { XMLHttpRequest, window }
import ceylon.interop.browser.dom { Event, HTMLElement }
import ceylon.time {
    fixedTime
}
import scriptbowl.chat.common {
    parseMessage
}
"This is called when the list of new messages is received."
void doLoadMessages(XMLHttpRequest req)(Event event) {
    if (is JsonArray resp = parse(req.responseText)) {
        value sb = StringBuilder();
        value sbd = StringBuilder();
        variable value lts = client.lastTimestamp;
        for (jsm in resp) {
            if (is JsonObject jsonMessage = jsm,
                    exists msg = parseMessage(jsonMessage)) {
                String txt = "<p><i>``msg.time``</i> <b>``msg.from``:</b>
                              ``msg.message``</p>";
                if (exists dm = msg.to) {
                    sbd.append(txt);
                } else {
                    sb.append(txt);
                }
                if (msg.timestamp > lts) {
                    lts = msg.timestamp;
                }
            }
        }
        if (sb.empty && client.lastTimestamp == 0) {
            if (exists e = window.document.getElementById("chat")) {
                e.innerHTML = "Nothing has been said yet. Start a conversation!";
            }
        } else {
            client.appendToChat(sb.string);
            client.lastTimestamp = lts;
        }
        if (!sbd.empty) {
            client.appendToDM(sbd.string);
        }
        //TODO DM's
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
    if (is JsonObject resp = parse(req.responseText)) {
        if (exists ts = resp.getIntegerOrNull("t")) {
            String msg;
            dynamic {
                msg = document.getElementById("txt").\ivalue else "<NO TXT>";
            }
            value newMessage = "<p><i>``fixedTime(ts).instant().time()``</i>
                                <b>``client.username``:</b>
                                ``msg.replace("<", "&lt;").replace(">", "&gt;")``</p>";
            client.appendToChat(newMessage);
            client.lastTimestamp = ts;
            if (is HTMLElement e = window.document.getElementById("txt")) {
                dynamic {
                    document.getElementById("txt").\ivalue = "";
                }
                e.focus();
            }
            return;
        } else if (exists err = resp.getStringOrNull("error")) {
            dynamic {
                alert("Could not send message:
                       ``err``");
            }
            return;
        }
    }
    dynamic {
        alert("Something bad happened:
               ``req.responseText``");
    }
}

"This method is called by the Send button, to add a message to the chat."
Boolean submit(Event event) {
    if (client.loggedIn) {
        String txt;
        dynamic {
            txt = document.getElementById("txt")?.\ivalue else "???NO TEXT!!!";
        }
        //Check if it's a direct message
        value [msg, dst] =
            if (txt.startsWith("@"), exists p0 = txt.firstOccurrence(' '))
            then [txt.spanFrom(p0+1).trimmed, txt[1..p0].trimmed]
            else [txt.trimmed, null];
        if (!msg.empty) {
            value url = (dst exists then client.urlDM else client.urlSubmit)
                .replace("USER", encodeParam(client.token))
                .replace("MSG", encodeParam(msg));
            if (exists dst) {
                xhr(url.replace("DST", encodeParam(dst)), doSubmit);
            } else {
                xhr(url, doSubmit);
            }
        }
    }
    return false;
}
