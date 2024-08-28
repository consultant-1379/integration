pipelineJob('udm-5g-adp-common-registration') {

    properties {
        disableConcurrentBuilds()
    }

    logRotator(-1, 15, 1, -1)

    authorization {
        permission('hudson.model.Item.Read:authenticated')
        permission('hudson.model.Item.Build:authenticated')
        permission('hudson.model.Item.Cancel:authenticated')
        permission('hudson.model.Item.Workspace:authenticated')
    }

    parameters {
        booleanParam(
            'DEBUG',
            false,
            'Activate extra debug logs')
        stringParam(
            'DROP_NAME',
            '',
            'i.e.: "DROP82"'
        )
        choiceParam(
            'PACKAGE_NAME',
            ['eric-adp-5g-udm', 'eric-udm-mesh-integration'],
            'Currently supported ADP packages'
        )
        stringParam('PACKAGE_TAG', '', 'i.e.: "1.82.1+2"')
        stringParam(
            'MUNIN_TOKEN',
            '0.AREA60zokv37q0e-UggMa4eVP8_KjUkXc7xAvHtPAhE63o4RAI4.AgABAAEAAAAmoFfGtYxvRrNriQdPKIZ-AgDs_wUA9P_NTtGFFSEkcwkZpcK6SdvePXxIcZDh2MMTA_3k6o1TALluLfERVmSuEH1_6ZutBEvz94aPKXprnhFH8C1l05kNSA2Q_rm-A4Hm46tQcucB-dqO60KbpUWbv_nWE0XarQBiaqH97CYRRkGf8V_rmphbgKsc4gpAwiODydYJGZjD8D8EVnHHEhX4AOqHAWzM-wHXOnlmmP2isMGsTYVbFznX419FY-X4EhB9oFzkrzzwioJRGG4Ei9yBSsOgSQGgHNg1Ghq8VniOn2-Od9G4F7fOkfjFhrlz0hqb6Q6eIP8oL89d1Nz8E9ehvICIRmFriMBu2s_s2_pr8zSIFomiXQBetmXTTzkMjBrxezFs9YzwQ-U3OkFHocgnTxt-vB8-q3ForOnbvZyBwqZExsev0ndHXvwpp8WI9-MVMkwFQZCW3PqegZmsbpVXospTVyiIqNNvsKkmKRVpw4cMxMgnJWXDFSpg8vsRD4nMvP0iQICOdBdADLF-tFa2I_7l0jXpgL1TsF-NpN_0NnxH2VFqy6qOANBHfkg_B55j8WBUPdOprqmdMAfN7GwGcJHMFVPJ32PsnvfGok6zJQJXOF1j44Yqx6Nkoy4YgUgprM1BNDEJG7dD2X2cImz8ACykF9qLa3DOinGpO23LhNzeP4xxZD1M49VaOuum6UmBG0ShseyciOJrkH5EG-S8LKbOeqec0kKLUchHY7IwUkJ6RxSodWKFjO5coeZCNb9mHhjVJj8VcHCKwaTXWXRaGv7ri20ferTFzNs5-jplN2R_CstRsNupJOLZwwZv3Uqm9Oh5nk3qx6tPoUByPz4-jbaDzy9ybimMwftZ59lPjmvVQxLwk7ztWeRHgJg02_vrKMWPpH8WIhiyBxEm1RXi1Q',
            'Munin account token needed to run operations requiring authentication')
    }

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        name('origin')
                        url('https://madridci@${COMMON_GERRIT_URL}/a/HSS/CM_team')
                        credentials('userpwd-hss')
                        branch('master')
                        refspec('')
                    }
                    extensions {
                        wipeOutWorkspace()
                    }
                }
                scriptPath('analyze/ci/jenkinsfile.analyzeAdp')
            }
        }
    }
}
