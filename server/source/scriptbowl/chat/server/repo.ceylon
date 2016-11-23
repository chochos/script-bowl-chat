import com.redhat.ceylon.cmr.ceylon {
    CeylonUtils
}
import java.util { Arrays }
import com.redhat.ceylon.cmr.api {
    RepositoryManager
}
import ceylon.interop.java {
    javaString
}

RepositoryManager repoManager(String* repos) =>
    CeylonUtils.repoManager().extraUserRepos(
        Arrays.asList ( for (r in repos) javaString(r) ))
    .buildManager();
