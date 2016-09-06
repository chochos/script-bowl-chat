"A dynamic interface for the XMLHttpRequest object."
shared dynamic XHR {
    shared formal void open(String method, String url, Boolean async=true,
        String username="", String password="");
    shared formal void send();
    shared formal void addEventListener(String event, Anything() f);
    shared formal String responseText;
}

"Makes an async request with the function returned
 by [[f]] as a callback."
shared void xhr(
        "The URL to send the request to."
        String url,
        "A function that receives the XHR object and returns a callback
         for then the response is received."
        Anything()(XHR) f) {
    XHR r;
    dynamic {
        r = XMLHttpRequest();
    }
    r.addEventListener("load", f(r));
    r.open("GET", url);
    r.send();
}

"Initial setup for the client."
shared void setup() {
    dynamic {
        document.getElementById("logon").onclick=login;
        document.getElementById("send").onclick=submit;
        document.getElementById("form").onsubmit=submit;
        document.getElementById("txt").focus();
    }
    print("Setup OK! Ceylon ``language.version`` runtime ``runtime.version``");
}
