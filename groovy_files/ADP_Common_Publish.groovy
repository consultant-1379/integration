pipelineJob('udm-5g-adp-common-publish') {

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
        stringParam(
            'CHART_NAME',
            '',
            'Name of the chart built in the Staging Prepare to be promoted'
        )
        stringParam(
            'CHART_REPO',
            '',
            'Version of the chart built in the Staging Prepare to be promoted'
        )
        stringParam(
            'CHART_VERSION',
            '',
            'Repository of the chart built in the Staging Prepare to be promoted'
        )
        stringParam (
            'GERRIT_REFSPEC',
            ' ',
            """Refspec for 5gcicd/integration repository. This parameter takes prevalence over
            the CHART_* parameters. It will download the specified refspec to prepare a new version of
            eric-adp-5g-udm helm chart"""
        )
        stringParam (
            'GERRIT_BRANCH',
            'master',
            'Branch that will be used to clone source code from 5gcicd/integration repository,It should use the branch name like "master" instead of the commitId '
        )
        stringParam (
            'CLOUD',
            'eccd-ans-udm70935',
            'To choose a different cluster from default one.<br><br>'
        )
        stringParam (
            'VERSION_STRATEGY',
            'PATCH',
            'Strategy for chart version uplift in prepare and publish step'
        )
        stringParam (
            'ALWAYS_RELEASE',
            'True',
            'Always use upload to released repo with released version'
        )
        stringParam (
            'JENKINS_GERRIT_BRANCH',
            'master',
            'Branch that will be used to clone Jenkinsfile from 5gcicd/integration repository'
        )
        stringParam (
            'JENKINS_GERRIT_REFSPEC',
            '${GERRIT_REFSPEC}',
            """Refspec for 5gcicd/integration repository. This parameter takes prevalence over
            the CHART_* parameters. It will download the specified refspec to prepare a new version of
            eric-adp-5g-udm or helm chart.
            This parameter is also used to clone the Jenkinsfile that will run the job"""
        )
        stringParam (
            'PIPELINE_EXEC_ID',
            'master',
            'This parametar represent execution ID for Grafana dashboard',
        )
        stringParam('GERRIT_EVENT_TYPE', '', '')
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
                scriptPath('cicd/Jenkinsfile.publish')
            }
        }
    }
}
