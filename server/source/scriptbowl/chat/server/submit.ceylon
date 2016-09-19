import ceylon.http.server {
    Request,
    Response
}
import ceylon.json { JsonObject }

"Invoked when a user submits a message, which can be public or a DM
 to a certain user."
void submit(Request req, Response resp) {
    value u = auth(req, resp);
    if (is User u) {
        if (exists m = req.queryParameter("m")) {
            Message msg;
            if (exists to = req.queryParameter("d"), !to.empty) {
                if (server.isLoggedIn(to)) {
                    msg = Message(u.name, m, to);
                } else {
                    print("Ignoring message from ``u.name`` to invalid user ``to``");
                    error(resp, "User ``to`` is not logged in, cannot send DM");
                    return;
                }
            } else {
                msg = Message(u.name, m);
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
