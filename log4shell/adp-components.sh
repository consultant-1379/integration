#!/bin/bash

# label "app.kubernetes.io/name" of all impacted ADP service should be listed here
ADP_MICROS=( \
    "eric-ctrl-bro" \
    "eric-data-coordinator-zk" \
    "eric-data-coordinator-zk-agent" \
    "eric-data-distributed-coordinator-ed" \
    "eric-data-distributed-coordinator-ed-agent" \
    "eric-data-document-database-pg" \
    "eric-data-document-database-pg-ah" \
    "eric-data-document-database-pg-iam" \
    "eric-data-document-database-pg-lm" \
    "eric-data-message-bus-kf" \
    "eric-data-search-engine" \
    "eric-data-wide-column-database-cd" \
    "eric-fh-alarm-handler" \
    "eric-fh-snmp-alarm-provider" \
    "eric-lm-combined-server" \
    "eric-log-transformer" \
    "eric-sec-certm" \
    "eric-sec-ldap-server" \
)
