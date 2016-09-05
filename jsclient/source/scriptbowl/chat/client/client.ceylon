shared object client {
    shared variable String token = "";
    shared variable Integer lastTimestamp=0;

    shared Boolean loggedIn => !token.empty;

    shared String urlLogin = "http://localhost:8080/login/USER";
    shared String urlUsers = "http://localhost:8080/users/USER";
    shared String urlMessages = "http://localhost:8080/fetch/USER/TS";
    shared String urlLogout = "http://localhost:8080/logout/USER";
    shared String urlSubmit = "http://localhost:8080/submit/USER/MSG/";
    shared String urlDM = "http://localhost:8080/submit/USER/MSG/DST";
}
