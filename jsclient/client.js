require.config({
    baseUrl: "modules",
    waitSeconds: 5
});

require(["ceylon/language/1.3.0/ceylon.language-1.3.0",
    'scriptbowl/chat/client/1.0.0/scriptbowl.chat.client-1.0.0'], function(cl, chat) {
    chat.setup();
});
