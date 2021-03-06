import ceylon.http.server {
    Request,
    Response
}
import ceylon.json { JsonObject }
import scriptbowl.chat.common {
    Message
}

"Invoked when a user submits a message, which can be public or a DM
 to a certain user."
void submit(Request req, Response resp) {
    value u = auth(req, resp);
    if (is User u) {
        if (exists m = req.queryParameter("m")) {
            Message msg;
            value escapedMessage = m.replace("<", "&lt;").replace(">", "&gt;");
            if (exists to = req.queryParameter("d"), !to.empty) {
                if (server.isLoggedIn(to)) {
                    msg = Message(u.name, escapedMessage, to);
                } else {
                    print("Ignoring message from ``u.name`` to invalid user ``to``");
                    error(resp, "User ``to`` is not logged in, cannot send DM");
                    return;
                }
            } else {
                msg = Message(u.name, escapedMessage);
            }
            server.addMessage(msg);
            writeJson(resp, JsonObject {
                    "t" ->  msg.timestamp
            });
        } else {
            error(resp, "You must specify a message and an optional receiver.");
        }
    } else {
        error(resp, u);
    }
}
