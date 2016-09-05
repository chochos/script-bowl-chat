shared object client {
    shared variable String username = "";
    shared variable String token = "";
    shared variable Integer lastTimestamp=0;

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
