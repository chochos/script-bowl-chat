import ceylon.interop.browser { window, XMLHttpRequest, newXMLHttpRequest }
import ceylon.interop.browser.dom { Event,
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
    if (exists e = window.document.getElementById("logon")) {
        e.addEventListener("click", object satisfies EventListener {
            handleEvent = login;
        });
    }
    if (exists e = window.document.getElementById("send")) {
        e.addEventListener("click", object satisfies EventListener {
            handleEvent = submit;
        });
    }
    if (exists e = window.document.getElementById("form")) {
        e.addEventListener("submit", object satisfies EventListener {
            handleEvent = submit;
        });
    }
    if (exists e = window.document.getElementById("powered")) {
        e.innerHTML = "Powered by Ceylon ``language.version``";
    }
}

String encodeParam(String param) {
    dynamic {
        return encodeURIComponent(param);
    }
}
