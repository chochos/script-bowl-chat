import ceylon.collection { HashMap,
    ArrayList }
import ceylon.json {
    JsonObject
}

object server {
    value users = HashMap<String,User>();
    value messages = ArrayList<Message>(16, 2.0);

    shared String addUser(User user) {
        value token = tokenForUser(user);
        print("Adding ``user.name`` => ``token``");
        users[token] = user;
        return token;
    }
    shared Boolean removeUser(String username) {
        print("Removing ``username``");
        return users.remove(username) exists;
    }
    shared User? getUser(String username) => users[username];
    shared Boolean isLoggedIn(String username) =>
        users.find((t->u) => u.name == username) exists;

    shared void addMessage(Message m) {
        if (exists to=m.to) {
            print("New message from ``m`` (DM to ``to``)");
        } else {
            print("New message from ``m``");
        }
        messages.add(m);
    }
    "Return the messages excluding the specified source, with a timestamp
     later than the one specified."
    shared [Message*] listMessages(String username, Integer since) =>
        { for (m in messages) if (m.timestamp > since && m.canShowTo(username)) m }
            .sort((x, y) => x.timestamp <=> y.timestamp);

    shared [User*] listUsers(String exclude) =>
        [ for (k->u in users) if (u.name != exclude) u];

    String tokenForUser(User u) => "``u.name``_``u.since``";
}

"A message from a user"
class Message(from, message, to=null, timestamp=system.milliseconds) {
    shared String from;
    shared String? to;
    shared String message;
    shared Integer timestamp;
    "Determines if the message should be shown to the specified user.
     This means that the message is intended for the user, or wasn't
     sent by the user."
    shared Boolean canShowTo(String user) {
        if (exists receiver=to) {
            return receiver==user;
        }
        return from != user;
    }
    shared JsonObject toJson() =>
        if (exists t=to) then
            JsonObject{ "from"->from, "to"->t, "t"->timestamp, "m"->message}
        else
            JsonObject{ "from"->from, "t"->timestamp, "m"->message};
    shared actual String string = "``from``: ``message``";
}

"A user that's logged into the chat server"
class User(name, since=system.milliseconds) {
    shared String name;
    shared Integer since;
    shared JsonObject toJson() =>
        JsonObject{"name"->name,"since"->since};
}
