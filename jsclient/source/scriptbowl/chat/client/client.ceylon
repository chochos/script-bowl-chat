import ceylon.interop.browser { window }

"An object containing shared information for the client functions."
shared object client {
    "The username chosen for the chat."
    shared variable String username = "";
    "The token returned by the server for authentication."
    shared variable String token = "";
    "The timestamp of the last message sent or received."
    shared variable Integer lastTimestamp=0;

    "Tells whether the user has been already logged in."
    shared Boolean loggedIn => !token.empty;

    String host = "http://localhost:8080";
    shared String urlLogin = host + "/login?u=USER";
    shared String urlUsers = host + "/users?u=USER";
    shared String urlMessages = host + "/fetch?u=USER&t=TS";
    shared String urlLogout = host + "/logout?u=USER";
    shared String urlSubmit = host + "/submit?u=USER&m=MSG";
    shared String urlDM = host + "/submit?u=USER&m=MSG&d=DST";

    "Appends the specified HTML to the already existing text in the
     chat section, scrolling to the bottom if needed."
    shared void appendToChat(String html) {
        if (exists chatDiv = window.document.getElementById("chat")) {
            chatDiv.innerHTML += html;
            chatDiv.scrollTop = chatDiv.scrollHeight;
        }
    }
    "Appends the specified HTML to the already existing text in the
     DM section, scrolling to the bottom if needed."
    shared void appendToDM(String html) {
        if (exists dms = window.document.getElementById("dms")) {
            dms.innerHTML += html;
            dms.scrollTop = dms.scrollHeight;
        }
    }
}
