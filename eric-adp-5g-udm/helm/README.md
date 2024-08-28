# Ericsson 5G@UDM ADP Generic Services

Helm package which installs the Ericsson common ADP Generic Services needed for
5G@UDM deployment.

## Helm package content

This package links to __Ericsson ADP Generic Services__ dependencies:

| Service Name                      | Chart Service Name                    |
| --------------------------------- |:-------------------------------------:|
| Document Database PG              | eric-data-document-database-pg        |
| CM Mediator                       | eric-cm-mediator                      |
| CM YANG Provider                  | eric-cm-yang-provider                 |
| PM Server                         | eric-pm-server                        |
| PM Bulk Reporter                  | eric-pm-bulk-reporter                 |
| Data Coordinator ZK               | eric-data-coordinator-zk              |
| Data Message Bus KF               | eric-data-message-bus-kf              |
| Log Shipper                       | eric-log-shipper                      |
| Search Engine                     | eric-data-search-engine               |
| Alarm Handler                     | eric-fh-alarm-handler                 |
| SNMP Alarm Provider               | eric-fh-snmp-alarm-provider           |
| Search Engine Curator             | eric-data-search-engine-curator       |
| Diagnostic Data Collector         | eric-odca-diagnostic-data-collector   |
| Log Transformer                   | eric-log-transformer                  |
| Backup and Restore Orchestrator   | eric-ctrl-bro                         |
| Identity and Access Management    | eric-sec-access-mgmt                  |
| LDAP server                       | eric-sec-ldap-server                  |
| Key Management                    | eric-sec-key-management               |
| Service Identity Provider TLS     | eric-sec-sip-tls                      |
| Distributed Coordinator ED        | eric-data-distributed-coordinator-ed  |
| CNOM server                       | eric-cnom-server                      |
| Ingress Controller CR             | eric-tm-ingress-controller-cr         |
| License Manager                   | eric-lm-combined-server               |
| Certificate Management            | eric-sec-certm                        |
| Unique Object Reporter            | eric-lm-unique-object-reporter        |
| Admin User Management             | eric-sec-admin-user-management        |
| Object Storage MN                 | eric-object-storage-mn                |
| Application Sys Info Handler      | eric-si-application-sys-info-handler  |
| PM Resource Monitor               | eric-pm-resource-monitor              |
| Distributed Trace Collector       | eric-dst-collector                    |
| Distributed Trace Query           | eric-dst-query                        |
| Probe Virtual Tap Broker          | eric-probe-virtual-tap-broker         |
| Service Mesh                      | eric-mesh-integration                 |

For more details about the __Ericcson ADP Generic Services__ versions and information,
open the [ADP Marketplace](http://adp.ericsson.se/marketplace "ADP Ericsson Marketplace's Homepage")

## Install this package

This Helm package supports several installation procedures based on below installation principle:

The condition `eric-adp-common.enabled` is the first to be evaluated, so when
it is set in values it always will override subsequent conditions:

* `--set eric-adp-common.enabled=true` will install all the __5G@UDM ADP Generic Services__
* `--set eric-adp-common.enabled=false` will not install any of the __5G@UDM ADP Generic Services__

Helm package contains `values.yaml` file with several `tags` fields, they will be evaluated
and used to control loading for the __5G@UDM ADP Generic Services__ chart(s) they are applied to.

### Install all the 5G@UDM ADP Generic Services

Install all the __5G@UDM ADP Generic Services__ included in above section **_Helm package content_**.

```
helm install eric-adp-5g-udm --name eric-adp-5g-udm --namespace adp-udm \
--set eric-adp-common.enabled=true \
--namespace 5g-udm-adp
```

## Uninstall this package

```
helm del --purge eric-adp-5g-udm
```

## NOTES

Due to [Quick Study for the uplift to Service Mesh 2.0][Quick Study], a [small
PoC][SM annotation PoC] was done and an annotation has been added with the
Service Mesh version. For now, *this needs to be changed manually whenever
there's an uplift of Service Mesh*.

[Quick Study]: https://ericsson-my.sharepoint.com/:p:/p/pablo_martinez_de_la_cruz/ESt2w0IsF6tNug95wCul-scBnj8ssQDMaAAsYcOclPF_cw?e=4AKQaq
[SM annotation PoC]: https://gerrit-gamma-read.seli.gic.ericsson.se/plugins/gitiles/udmp_pocs/sm_annotations/

 