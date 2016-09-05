require.config({
    baseUrl: "/Users/ezamudio/Projects/ceylon/ceylon",
    waitSeconds: 5,
	paths:{
		'ceylon/language':'compiler-js/build/runtime/ceylon/language',
        'scriptbowl':'../otros/script-bowl-chat/jsclient/modules/scriptbowl'
	}
});

require(["ceylon/language/1.2.3/ceylon.language-1.2.3",
    'scriptbowl/chat/client/1.0.0/scriptbowl.chat.client-1.0.0'], function(cl, chat) {
    cl.print(cl.$_String("puto",4));
    cl.$_process().write("probando 1 ");
    cl.$_process().write("probando 2 ");
    cl.$_process().writeLine("Probando 3");
    cl.$_process().writeLine("Probando 4");
    cl.print(cl.runtime().version);
});
