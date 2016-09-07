import ceylon.interop.browser { XMLHttpRequest, newXMLHttpRequest }
import ceylon.interop.browser.dom { Event }

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
    dynamic {
        document.getElementById("logon").onclick=login;
        document.getElementById("send").onclick=submit;
        document.getElementById("form").onsubmit=submit;
        document.getElementById("txt").focus();
    }
    print("Setup OK! Ceylon ``language.version`` runtime ``runtime.version``");
}

String encodeParam(String param) {
    dynamic {
        return encodeURIComponent(param);
    }
}
