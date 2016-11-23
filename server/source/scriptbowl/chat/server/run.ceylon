import java.lang { System }
import ceylon.http.server { newServer, Endpoint,
    Options,
    equals,
    Response,
    AsynchronousEndpoint,
    isRoot,
    endsWith,
    startsWith }
import ceylon.io {
    SocketAddress
}
import ceylon.json { JsonObject,
    JsonArray }
import ceylon.http.common {
    contentType,
    contentLength
}
import ceylon.http.server.endpoints {
    serveStaticFile,
    serveModule
}
import ceylon.buffer.charset {
    utf8
}

"The entry point for the chat server."
shared void run() {
    "You must specify a port through the server.port system property"
    assert(is Integer port = Integer.parse(System.getProperty("server.port", "8080")));
    value manager = repoManager("/Users/ezamudio/Projects/ceylon/otros/script-bowl-chat/modules",
        "/Users/ezamudio/.sdkman/candidates/ceylon/current/repo",
        "https://herd.ceylon-lang.org/repo/1"
    );
    value server = newServer {
        Endpoint {
            path = equals("/login");
            login;
        },
        Endpoint {
            path = equals("/logout");
            logout;
        },
        Endpoint {
            path = equals("/submit");
            submit;
        },
        Endpoint {
            path = equals("/fetch");
            fetchMessages;
        },
        Endpoint {
            path = equals("/users");
            fetchUsers;
        },
        AsynchronousEndpoint {
            path = isRoot();
            service = serveStaticFile("jsclient/index.html");
        },
        AsynchronousEndpoint {
            path = startsWith("/modules");
            service = serveModule(manager, "/modules");
        },
        AsynchronousEndpoint {
            path = endsWith(".js").or(endsWith(".css"));
            service = serveStaticFile {
                externalPath = "jsclient";
            };
        }
    };
    server.start(SocketAddress("localhost", port),
        Options { sessionId = "script-bowl-server"; });
}

"Write an error message to the response."
void error(Response resp, String message) =>
    writeJson(resp, JsonObject{ "error"->message });

"Write a JSON object to the response."
void writeJson(Response resp, JsonObject|JsonArray data) {
    value content = data.string;
    resp.addHeader(contentType("application/json", utf8));
    resp.addHeader(contentLength(content.size.string));
    resp.writeString(content);
    resp.flush();
}
