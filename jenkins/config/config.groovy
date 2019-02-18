// Common configuration
// config.groovy

import jenkins.*
import jenkins.model.*
import jenkins.model.Jenkins
import jenkins.security.s2m.AdminWhitelistRule
import hudson.*
import hudson.model.*

// Set amount of executors
Jenkins.instance.setNumExecutors(10)

// Disable CLI remoting
// https://support.cloudbees.com/hc/en-us/articles/234709648-Disable-Jenkins-CLI
jenkins.CLI.get().setEnabled(false)

// Enable the access control mechanism (Slave To Master Access Control)
// https://wiki.jenkins.io/display/JENKINS/Slave+To+Master+Access+Control
Jenkins.instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

def jenkinsInstance = Jenkins.getInstance()

// Define proxy for instance
String name = "proxy.srv.scpdev"
int port = 3128
String userName = ""
String password = ""
String noProxyHost = ""

def jenkinsProxy = new hudson.ProxyConfiguration(name, port, userName, password, noProxyHost)
jenkinsInstance.proxy = jenkinsProxy
jenkinsInstance.save()

// Install additional plugins

def pluginParameter="maven-plugin pipeline-maven gradle jsch conditional-buildstep credentials-binding cloudbees-credentials"
def plugins = pluginParameter.split()
println(plugins)
def pm = jenkinsInstance.getPluginManager()
def uc = jenkinsInstance.getUpdateCenter()
def installed = false

plugins.each {
  if (!pm.getPlugin(it)) {
    def plugin = uc.getPlugin(it)
    if (plugin) {
      println("Installing " + it)
      plugin.deploy()
      installed = true
    }
  }
}

jenkinsInstance.save()
if (installed)
jenkinsInstance.doSafeRestart()

// Define slave

//EOF