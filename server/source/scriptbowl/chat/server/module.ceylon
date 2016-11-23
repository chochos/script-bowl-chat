"A chat server example for the JavaOne 2016 Script Bowl."
by("Enrique Zamudio")
native ("jvm")
module scriptbowl.chat.server "1.0.1" {
    import ceylon.http.server "1.3.1";
    import ceylon.json "1.3.1";
    import ceylon.interop.java "1.3.1";
    import java.base "8";
    import scriptbowl.chat.common "1.0.1";
}
