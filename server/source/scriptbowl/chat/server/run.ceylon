import java.lang { System, JString=String }
import ceylon.http.server { newServer, Endpoint,
    Options,
    template,
    Response,
    AsynchronousEndpoint,
    isRoot,
    endsWith,
    startsWith }
import ceylon.io {
    SocketAddress
}
import ceylon.json { Json=Object,
    JsonArray }
import ceylon.http.common {
    contentType,
    contentLength
}
import ceylon.http.server.endpoints {
    serveStaticFile,
    serveModule
}
import com.redhat.ceylon.cmr.ceylon {
    CeylonUtils
}
import java.util {
    Arrays
}
import ceylon.interop.java {
    javaString
}

"The entry point for the chat server."
shared void run() {
    "You must specify a port through the server.port system property"
    assert(exists port = parseInteger(System.getProperty("server.port", "8080")));
    value repos = Arrays.asList<JString>(
        javaString("/Users/ezamudio/Projects/ceylon/ceylon/compiler-js/build/runtime"),
        javaString("/Users/ezamudio/Projects/ceylon/otros/script-bowl-chat/jsclient/modules"),
        javaString("/Users/ezamudio/Projects/ceylon/ceylon/dist/dist/repo"),
        javaString("/Users/ezamudio/Projects/ceylon/ceylon-sdk/modules"));
    value manager = CeylonUtils.repoManager().extraUserRepos(repos).buildManager();
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
