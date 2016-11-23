import ceylon.interop.browser { window, XMLHttpRequest, newXMLHttpRequest }
import ceylon.interop.browser.dom {
    Event,
    EventListener }

"Makes an async request with the function returned
 by [[f]] as a callback."
void xhr(
        "The URL to send the request to."
        String url,
        "A function that receives the XHR object and returns a callback
         for then the response is received."
        Anything(Event)(XMLHttpRequest) f) {
    XMLHttpRequest r = newXMLHttpRequest();
    r.onload = f(r);
    r.open("GET", url);
    r.send();
}

"Initial setup for the client."
shared void setup() {
    value doc = window.document;
    void addListener(String elementName, String eventName, Anything(Event) handler) {
        if (exists e = doc.getElementById(elementName)) {
            e.addEventListener(eventName, object satisfies EventListener {
                handleEvent = handler;
            });
        }
    }
    addListener("logon", "click", login);
    addListener("send", "click", submit);
    addListener("form", "submit", submit);
    if (exists e = doc.getElementById("powered")) {
        e.innerHTML = "Powered by Ceylon ``language.version``";
    }
}

String encodeParam(String param) {
    dynamic {
        return encodeURIComponent(param);
    }
}
