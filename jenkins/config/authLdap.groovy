// LDAP authentication

import jenkins.*
import jenkins.model.*
import hudson.*
import hudson.model.*
import hudson.security.*
import hudson.plugins.sshslaves.*
import org.jenkinsci.plugins.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*

userIdArray = [
    "User1",
    "User2",
    "User3",
    "User4",
    "User5",
    "User6",
    "User7",
    "User8",
    "User9",
    "User10",
    "User11"
    ] as String[]

def jenkinsInstance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)

//  LDAP setup
String server = 'ldap://10.96.2.101'
String rootDN = 'dc=beta,dc=scp'
String userSearchBase = 'cn=users,cn=accounts'
//String userSearch = 'uid={0}'
String userSearch = ''
String groupSearchBase = ''
String managerDN = 'uid=knkz835,cn=users,cn=accounts,dc=beta,dc=scp'
String managerPassword = 'apotekill*0852'
boolean inhibitInferRootDN = false

// Define realm
SecurityRealm ldap_realm = new LDAPSecurityRealm(
    server,
    rootDN,
    userSearchBase,
    userSearch,
    groupSearchBase,
    managerDN,
    managerPassword,
    inhibitInferRootDN)

// Define strategy
def strategy = new hudson.security.GlobalMatrixAuthorizationStrategy()

// Define administrators
strategy.add(Jenkins.ADMINISTER,'User1')
strategy.add(Jenkins.ADMINISTER,'User2')

jenkinsInstance.setAuthorizationStrategy(strategy)


// Define regular users
for (i = 0; i < userIdArray.length; i++) {
    //// Define Matrix-based security and matrix of permissions for users
    // Overall
    strategy.add(hudson.model.Hudson.READ, userIdArray[i])
    // Agent
    strategy.add(Jenkins.MasterComputer.BUILD, userIdArray[i])
    strategy.add(Jenkins.MasterComputer.CONFIGURE, userIdArray[i])
    strategy.add(Jenkins.MasterComputer.CONNECT, userIdArray[i])
    strategy.add(Jenkins.MasterComputer.CREATE, userIdArray[i])
    strategy.add(Jenkins.MasterComputer.DELETE, userIdArray[i])
    strategy.add(Jenkins.MasterComputer.DISCONNECT, userIdArray[i])
    // Jobs
    strategy.add(hudson.model.Item.BUILD, userIdArray[i])
    strategy.add(hudson.model.Item.CANCEL, userIdArray[i])
    strategy.add(hudson.model.Item.CONFIGURE, userIdArray[i])
    strategy.add(hudson.model.Item.CREATE, userIdArray[i])
    strategy.add(hudson.model.Item.DELETE, userIdArray[i])
    strategy.add(hudson.model.Item.DISCOVER, userIdArray[i])
    strategy.add(hudson.model.Item.EXTENDED_READ, userIdArray[i])
    strategy.add(hudson.model.Item.READ, userIdArray[i])
    strategy.add(hudson.model.Item.WIPEOUT, userIdArray[i])
    strategy.add(hudson.model.Item.WORKSPACE, userIdArray[i])
    // Run
    strategy.add(hudson.model.Run.DELETE, userIdArray[i])
    strategy.add(hudson.model.Run.UPDATE, userIdArray[i])
    strategy.add(hudson.model.Run.ARTIFACTS, userIdArray[i])
    // View
    strategy.add(hudson.model.View.CONFIGURE, userIdArray[i])
    strategy.add(hudson.model.View.CREATE, userIdArray[i])
    strategy.add(hudson.model.View.DELETE, userIdArray[i])
    strategy.add(hudson.model.View.READ, userIdArray[i])
    // SCM
    strategy.add(hudson.scm.SCM.TAG, userIdArray[i])
    // Credentials
    strategy.add(CredentialsProvider.CREATE, userIdArray[i])
    strategy.add(CredentialsProvider.UPDATE, userIdArray[i])
    strategy.add(CredentialsProvider.VIEW, userIdArray[i])
    strategy.add(CredentialsProvider.DELETE, userIdArray[i])
    strategy.add(CredentialsProvider.MANAGE_DOMAINS, userIdArray[i])
    // Plugin Manager
    //strategy.add(hudson.model.Hudson.UPLOAD_PLUGINS, userIdArray[i])
    //strategy.add(hudson.PluginManager.UPLOAD_PLUGINS, userIdArray[i])
    //strategy.add(hudson.PluginManager.CONFIGURE_UPDATECENTER, userIdArray[i])
    jenkinsInstance.setAuthorizationStrategy(strategy)
}

jenkinsInstance.setSecurityRealm(ldap_realm)
jenkinsInstance.save()

//EOF