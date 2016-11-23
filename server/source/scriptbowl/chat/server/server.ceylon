import ceylon.collection { HashMap,
    ArrayList }
import ceylon.json {
    JsonObject
}
import scriptbowl.chat.common {
    Message
}

object server {
    value users = HashMap<String,User>();
    value messages = ArrayList<Message>(16, 2.0);

    shared String addUser(User user) {
        print("Adding ``user.name`` => ``user.token``");
        users[user.token] = user;
        return user.token;
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

}

"A user that's logged into the chat server"
class User(name, since=system.milliseconds) {
    shared String name;
    shared Integer since;
    shared JsonObject toJson() =>
        JsonObject { "name"->name,"since"->since};
    shared String token = "``name``_``since``";
}
