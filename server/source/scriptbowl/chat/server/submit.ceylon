import ceylon.http.server {
    Request,
    Response
}
import ceylon.json { JsonObject }

void submit(Request req, Response resp) {
    value u = auth(req, resp);
    if (is User u) {
        if (exists m=req.pathParameter("msg")) {
            Message msg = if (exists to = req.pathParameter("to"), !to.empty)
                then Message(u.name, m, to)
                else Message(u.name, m);
            server.addMessage(msg);
            writeJson(resp, JsonObject{"t"->msg.timestamp});
        } else {
            error(resp, "You must specify a message and an optional receiver.");
        }
    } else {
        error(resp, u);
    }
}
