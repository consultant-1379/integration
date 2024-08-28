pipelineJob('udm-5g-adp-common-deploy') {

    logRotator(-1, 50, 1, -1)
    authorization {
        permission('hudson.model.Item.Read', 'anonymous')
        permission('hudson.model.Item.Read:authenticated')
        permission('hudson.model.Item.Build:authenticated')
        permission('hudson.model.Item.Cancel:authenticated')
        permission('hudson.model.Item.Workspace:authenticated')
    }

    parameters {
        stringParam (
            'CHART_NAME',
            '',
            'Helm chart name part of requirements.yaml for eric-adp-5g-udm'
        )
        stringParam (
            'CHART_REPO',
            '',
            'Helm chart repository URL',
        )
        stringParam (
            'CHART_VERSION',
            '',
            'Helm chart version',
        )
        stringParam (
            'GERRIT_BRANCH',
            'master',
            'Branch that will be used to clone Jenkinsfile from 5gcicd/integration repository',
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
            'eccd-ans-udm19165',
            'To choose a different cluster from default one.<br><br>',
        )
        stringParam (
            'JENKINS_GERRIT_BRANCH',
            'master',
            'Branch that will be used to clone Jenkinsfile from 5gcicd/integration repository',
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
                scriptPath('cicd/Jenkinsfile.deploy')
            }
        }
    }
}
