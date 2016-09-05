require.config({
    baseUrl: "modules",
    waitSeconds: 5
});

require(["ceylon/language/1.2.3/ceylon.language-1.2.3",
    'scriptbowl/chat/client/1.0.0/scriptbowl.chat.client-1.0.0'], function(cl, chat) {
    cl.print(cl.runtime().version);
    //Login
    document.getElementById("logon").onclick=chat.login;
    document.getElementById("send").onclick=chat.submit;
});
