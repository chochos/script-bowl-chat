import java.lang { System }
import ceylon.http.server { newServer, Endpoint,
    Options,
    template,
    Response }
import ceylon.io {
    SocketAddress
}
import ceylon.json { Json=Object,
    JsonArray }
import ceylon.http.common {
    contentType,
    contentLength
}

"The entry point for the chat server."
shared void run() {
    "You must specify a port through the server.port system property"
    assert(exists port = parseInteger(System.getProperty("server.port", "8080")));
    value server = newServer {
        Endpoint {
            path = template("/login/{username}");
            login;
        },
        Endpoint {
            path = template("/logout/{username}");
            logout;
        },
        Endpoint {
            path = template("/submit/{username}/{msg}/{to}");
            submit;
        },
        Endpoint {
            path = template("/fetch/{username}/{since}");
            fetchMessages;
        },
        Endpoint {
            path = template("/users/{username}");
            fetchUsers;
        }
    };
    server.start(SocketAddress("localhost", port), Options{ sessionId = "script-bowl-server";});
}

"Write an error message to the response."
void error(Response resp, String message) {
    writeJson(resp, Json{ "error"->message });
}

"Write a JSON object to the response."
void writeJson(Response resp, Json|JsonArray data) {
    value content = data.string;
    resp.addHeader(contentType("application/json"));
    resp.addHeader(contentLength(content.size.string));
    resp.writeString(content);
    resp.flush();
}
