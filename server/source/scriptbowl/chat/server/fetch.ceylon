import ceylon.http.server {
    Request,
    Response
}
import ceylon.json { JsonArray }

void fetchMessages(Request req, Response resp) {
    value u = auth(req, resp);
    if (is User u) {
        if (exists ts = req.queryParameter("t"),
            exists t = parseInteger(ts)) {
            writeJson(resp, JsonArray([for (m in server.listMessages(u.name, t)) m.toJson()]));
        } else {
            error(resp, "You must specify the earliest timestamp for messages to be returned.");
        }
    } else {
        error(resp, u);
        error(resp, "You must specify a username and the earliest timestamp");
    }
}

void fetchUsers(Request req, Response resp) {
    value u = auth(req, resp);
    if (is User u) {
        writeJson(resp, JsonArray([ for (usr in server.listUsers(u.name)) usr.toJson() ]));
    } else {
        error(resp, u);
    }
}
