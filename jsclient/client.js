require.config({
    baseUrl: "modules",
    waitSeconds: 5
});

require(["ceylon/language/1.3.1/ceylon.language-1.3.1",
    'scriptbowl/chat/client/1.0.1/scriptbowl.chat.client-1.0.1'], function(cl, chat) {
    chat.setup();
});
