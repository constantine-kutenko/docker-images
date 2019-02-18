// Jenkins jobs
// jobs.groovy

import jenkins.*
import hudson.*
import hudson.model.*
import hudson.plugins.git.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition
import com.cloudbees.hudson.plugins.folder.Folder

//
// Create job's folders from a list
//

def jenkinsInstance = jenkins.model.Jenkins.getInstance()

// Define an array of folders' names
folderArray = ["Development", "Production"] as String[]

folderArray.each { item ->
  //println "${item}"
  def newProject = jenkinsInstance.createProject(Folder.class, item)
}

sleep(10)

//
// Create jobs from lists
//

// Define an array of jobs' names
jobsArrayDevelopment = 
["build_all", 
"tmp3"] as String[]

jobsArrayProduction = 
["build_and_test_package_centos", 
"build_and_test_package_centos-ME_User1", 
"build_and_test_package_centos_ME-User2", 
"build_and_test_package_centos_ME-User3", 
"build_and_test_package_centos_ME-User4", 
"build_and_test_package_centos_ME-User5",
"build_and_test_package_centos_ME-User6", 
"build_and_test_package_centos_ME-User7", 
"build_and_test_package_centos_ME-User8", 
"build_and_test_package_centos_ME-User9", 
"build_and_test_package_centos_ME-User10", 
"build_and_test_package_centos_ME-User11", 
"build_and_test_package_centos_ME-User12", 
"build_and_test_package_centos_ME-User13", 
"deploy_to_prod", 
"list_packages_on_prod", 
"remove_from_prod", 
"search_for_pkg_on_prod", 
"test_package_centos"] as String[]

// AZ
// Define a remote repository
// def scm = new GitSCM("ssh://git@stash.example.com:7999/scp/build_authomation.git")
// scm.branches = [new BranchSpec("*/master")];
// scm.userRemoteConfigs[0].credentialsId = "5c969692-8a91-4d51-8c59-6314c411442e"

// Test repository
def scm = new GitSCM("git@bitbucket.org:sethsh/build_automation.git")
scm.branches = [new BranchSpec("*/master")];
scm.userRemoteConfigs[0].credentialsId = "bitbucket_credential_id"

// Define flow from a file
def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "jenkins/build_and_test_package_centos.job")

// Define Lightweight checkout
flowDefinition.lightweight = true

// Create job in Development folder
folderItem = hudson.model.Hudson.instance.getItem(folderArray[0]) 
jobsArrayDevelopment.each { itemJobName ->
    //
    def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(folderItem, itemJobName)
    // Set job description
    job.setDescription('Detailed description is here:\nhttps://confluence.example.com/display/SCPMI/Building+with+Jenkins')
    job.definition = flowDefinition

    //// Create parameters for the job
    def parameterDefinitions = new ArrayList<ParameterDefinition>();
    // Define string parameters
    parameterDefinitions.add(new StringParameterDefinition('EASYCONFIG', 'f/foss/foss-2017s.eb', 'Path to easyconfig file') )
    parameterDefinitions.add(new StringParameterDefinition('BRANCH', 'master', 'Branch to use in building process') )
    parameterDefinitions.add(new StringParameterDefinition('SIZE_TEST_CONTAINER', '4000', 'megabytes, size of the test container thta jenkins will authomatically create.') )
    // Define boolean parameters
    parameterDefinitions.add(new BooleanParameterDefinition("UPDATE_CONFLUENCE", true, "Enable if a page in confluence should be created/updated. Enabled by default.") )
    // Define choice parameters
    parameterDefinitions.add(new ChoiceParameterDefinition("TEST_CONTAINER_TYPE", ['minimal','GUI-compatible'] as String[], "Defines software list...") )
    //Create a property for the job
    def jobProperty = new ParametersDefinitionProperty(parameterDefinitions);
    // Add property to the job
    job.addProperty(jobProperty)
    // Save job
    job.save()
    //
}

// Create jobs in Production folder
folderItem = hudson.model.Hudson.instance.getItem(folderArray[1]) 
jobsArrayProduction.each { itemJobName ->
    //
    def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(folderItem, itemJobName)
    // Set job description
    job.setDescription('Detailed description is here:\nhttps://confluence.example.com/display/SCPMI/Building+with+Jenkins')
    job.definition = flowDefinition

    //// Create parameters for the job
    def parameterDefinitions = new ArrayList<ParameterDefinition>();
    // Define string parameters
    parameterDefinitions.add(new StringParameterDefinition('EASYCONFIG', 'f/foss/foss-2017s.eb', 'Path to easyconfig file') )
    parameterDefinitions.add(new StringParameterDefinition('BRANCH', 'master', 'Branch to use in building process') )
    parameterDefinitions.add(new StringParameterDefinition('SIZE_TEST_CONTAINER', '4000', 'megabytes, size of the test container thta jenkins will authomatically create.') )
    // Define boolean parameters
    parameterDefinitions.add(new BooleanParameterDefinition("UPDATE_CONFLUENCE", true, "Enable if a page in confluence should be created/updated. Enabled by default.") )
    // Define choice parameters
    parameterDefinitions.add(new ChoiceParameterDefinition("TEST_CONTAINER_TYPE", ['minimal','GUI-compatible'] as String[], "Defines software list...") )
    //Create a property for the job
    def jobProperty = new ParametersDefinitionProperty(parameterDefinitions);
    // Add property to the job
    job.addProperty(jobProperty)
    // Save job
    job.save()
    //
}

jenkinsInstance.save()
jenkinsInstance.reload()

// Execute job
//def jobToBuild = hudson.model.Hudson.instance.getJob(JobFullName)
//hudson.model.Hudson.instance.queue.schedule(jobToBuild, 0)

//EOF