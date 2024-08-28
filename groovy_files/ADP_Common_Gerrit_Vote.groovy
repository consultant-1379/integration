pipelineJob('udm-5g-adp-common-gerrit-vote') {

    properties {
        disableConcurrentBuilds()
    }

    logRotator(-1, 15, 1, -1)
    authorization {
        permission('hudson.model.Item.Read', 'anonymous')
        permission('hudson.model.Item.Read:authenticated')
        permission('hudson.model.Item.Build:authenticated')
        permission('hudson.model.Item.Cancel:authenticated')
        permission('hudson.model.Item.Workspace:authenticated')
    }

    parameters {
        stringParam (
            'GERRIT_BRANCH',
            'master',
            "Branch that will be used to clone Jenkinsfile from 5gcicd/integration repository",
        )
        stringParam (
            'GERRIT_REFSPEC',
            ' ',
            """Refspec for 5gcicd/integration repository. This parameter takes prevalence over
            the CHART_* parameters. It will download the specified refspec to prepare a new version of
            eric-adp-5g-udm helm chart.
            This parameter is also used to clone the Jenkinsfile that will run the job"""
        )
        stringParam (
            'CLOUD',
            'eccd-ans-udm70935',
            'To choose a different cluster from default one.<br><br>'
        )
        stringParam (
            'TESTS_RESULT',
            'FAIL',
            'This parameter and DEPLOY_RESULT control whether Gerrit vote will be -1/+1'
        )
        stringParam (
            'DEPLOY_RESULT',
            'FAIL',
            'This parameter and TESTS_RESULT control whether Gerrit vote will be -1/+1'
        )
        stringParam (
            'JENKINS_GERRIT_BRANCH',
            'master',
            "Branch that will be used to clone Jenkinsfile from 5gcicd/integration repository",
        )
        stringParam (
            'JENKINS_GERRIT_REFSPEC',
            '${GERRIT_REFSPEC}',
            """Refspec for 5gcicd/integration repository. This parameter takes prevalence over
            the CHART_* parameters. It will download the specified refspec to prepare a new version of
            eric-adp-5g-udm helm chart.
            This parameter is also used to clone the Jenkinsfile that will run the job"""
        )
        stringParam (
            'PIPELINE_EXEC_ID',
            'master',
            'This parametar represent execution ID for Grafana dashboard',
        )
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        name('origin')
                        url('https://${COMMON_GERRIT_URL}/a/5gcicd/integration')
                        credentials('userpwd-adp')
                        refspec('${JENKINS_GERRIT_REFSPEC}')
                    }
                    branch('${JENKINS_GERRIT_BRANCH}')
                    extensions {
                        wipeOutWorkspace()
                        choosingStrategy {
                            gerritTrigger()
                        }
                    }
                }
                scriptPath('cicd/Jenkinsfile.gerrit_vote')
            }
        }
    }
}
