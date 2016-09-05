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
    shared String urlLogin = host + "/login/USER";
    shared String urlUsers = host + "/users/USER";
    shared String urlMessages = host + "/fetch/USER/TS";
    shared String urlLogout = host + "/logout/USER";
    shared String urlSubmit = host + "/submit/USER/MSG/";
    shared String urlDM = host + "/submit/USER/MSG/DST";

    "Appends the specified HTML to the already existing text in the
     chat section, scrolling to the bottom if needed."
    shared void appendToChat(String html) {
        dynamic {
            dynamic current = document.getElementById("chat").innerHTML;
            document.getElementById("chat").innerHTML = current + html;
        }
    }
}
