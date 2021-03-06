import ceylon.http.server {
    Request,
    Response
}
import ceylon.json {
    JsonObject
}

void login(Request req, Response resp) {
    if (exists uname = req.queryParameter("u")) {
        //Check for duplicates
        if (server.isLoggedIn(uname)) {
            print("``uname`` is already logged in.");
            error(resp, "User already logged in");
        } else {
            value t = server.addUser(User(uname));
            writeJson(resp, JsonObject{"token"->t,"name"->uname});
        }
    } else {
        error(resp, "You must specify a username.");
    }
}

void logout(Request req, Response resp) {
    value u = auth(req, resp);
    if (is User u) {
        server.removeUser(u.name);
        writeJson(resp, JsonObject{"logout"->system.milliseconds});
    } else {
        error(resp, u);
    }
}

"Authenticate the user from the request,
 returning an error message if something goes wrong."
User|String auth(Request req, Response resp) =>
    if (exists u = req.queryParameter("u"))
    then (server.getUser(u) else "Invalid user.")
    else "You must specify a username.";
