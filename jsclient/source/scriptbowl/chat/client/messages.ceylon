shared void doLoadMessages(XHR req)() {
    print("Messages: ``req.responseText``");
}

shared void loadMessages() {
    if (client.loggedIn) {
        xhr(client.urlMessages.replace("USER", client.token).replace("TS", "``client.lastTimestamp``"), doLoadMessages);
    }
}
