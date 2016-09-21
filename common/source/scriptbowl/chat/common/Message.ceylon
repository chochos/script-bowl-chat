import ceylon.json {
    JsonObject
}
import ceylon.time {
    fixedTime
}
"A message from a user."
shared class Message(from, message, to=null, timestamp=system.milliseconds) {
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
    "Returns a JSON object with the data for this object"
    shared JsonObject toJson() =>
        if (exists t=to) then
            JsonObject{ "from"->from, "to"->t, "t"->timestamp, "m"->message}
        else
            JsonObject{ "from"->from, "t"->timestamp, "m"->message};
    shared actual String string = "``from``: ``message``";
    "A string with the time of day when the message was created."
    shared String time = fixedTime(timestamp).instant().time().string;
}

"Creates a Message from a JSON object, if it has the right keys."
shared Message? parseMessage(JsonObject ob)
    => if (exists from = ob.getStringOrNull("from"),
        exists ts = ob.getIntegerOrNull("t"),
        exists msg = ob.getStringOrNull("m"))
    then Message(from, msg, ob.getStringOrNull("to"), ts)
    else null;
