"A chat server example for the JavaOne 2016 Script Bowl."
by("Enrique Zamudio")
native ("jvm")
module scriptbowl.chat.server "1.0.0" {
    import ceylon.http.server "1.3.0";
    import ceylon.json "1.3.0";
    import ceylon.interop.java "1.3.0";
    import java.base "8";
}
