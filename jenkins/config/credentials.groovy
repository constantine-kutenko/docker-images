// Credentials
// credentials.groovy

package com.cloudbees.plugins.credentials.impl

import jenkins.*
import hudson.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*
import hudson.model.*
import jenkins.model.*
import hudson.security.*


global_domain = Domain.global()

// Create credentials for easybuild-jenkins (SSH Username with private key)
credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentials = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL,
    "0d17a747-18fe-4627-a45f-21e432c8c7c4", 
    "easybuild-jenkins", 
    new BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource('/var/lib/jenkins/.ssh/id_rsa_easybuild-jenkins'), 
    "id1", 
    "easybuild-jenkins user on seskscpg001")
credentials_store.addCredentials(global_domain, credentials)

// Create credentials for jenkins (SSH Username with private key)
credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentials = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL, 
    "5c969692-8a91-4d51-8c59-6314c411442e",
    "jenkins",
    new BasicSSHUserPrivateKey.FileOnMasterPrivateKeySource('/var/lib/jenkins/.ssh/id_rsa_jenkins'),
    "id2",
    "jenkins deploy key for stash and SGW")
credentials_store.addCredentials(global_domain, credentials)

// Create credential for user jenkins
credentials_store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
credentials = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
	"fb598971-cd52-4434-8dc7-7ce538c520bd", 
	"easybuild-jenkins update",
	"easybuild-jenkins",
	"PUT_YOUR_PASSWORD_RIGHT_HERE")
credentials_store.addCredentials(global_domain, credentials)

//EOF