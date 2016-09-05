shared dynamic XHR {
    shared formal void open(String method, String url, Boolean async=true,
        String username="", String password="");
    shared formal void send();
    shared formal void addEventListener(String event, Anything() f);
    shared formal String responseText;
}

shared void xhr(String url, Anything()(XHR) f) {
    XHR r;
    dynamic {
        r = XMLHttpRequest();
    }
    r.addEventListener("load", f(r));
    r.open("GET", url);
    r.send();
}
