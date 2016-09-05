require.config({
    baseUrl: "modules",
    waitSeconds: 5
});

// Get the modal
var modal = document.getElementById('myModal');

// Get the button that opens the modal
var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks on <span> (x), close the modal
span.onclick = function() {
    modal.style.display = "none";
}

require(["ceylon/language/1.2.3/ceylon.language-1.2.3",
    'scriptbowl/chat/client/1.0.0/scriptbowl.chat.client-1.0.0'], function(cl, chat) {
    cl.print(cl.runtime().version);
    //Login
    document.getElementById("logon").onclick=chat.login;
});
