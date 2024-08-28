#!/bin/bash

source "adp-components.sh"

ENVIRONMENT_VARIABLE='LOG4J_FORMAT_MSG_NO_LOOKUPS="true"'
UPDATE_ADP_DEPLOYMENTS=0
UPDATE_CCXX_DEPLOYMENTS=0
UPDATE_ADP_DAEMONSETS=0
UPDATE_CCXX_DAEMONSETS=0
UPDATE_ADP_CRONJOBS=0
UPDATE_CCXX_CRONJOBS=0
UPDATE_ADP_STATEFULSETS=0
UPDATE_CCXX_STATEFULSETS=0
UPDATE_CCXX_GEODECLUSTERS=0
VERIFY=0
VERIFY_PODS=0
NAMESPACE=""

ADP_DEPLOYMENTS_NAME=()
ADP_DAEMONSETS_NAME=()
ADP_STATEFULSETS_NAME=()
ADP_CRONJOBS_NAME=()
CCXX_DEPLOYMENTS_NAME=()
CCXX_DAEMONSETS_NAME=()
CCXX_STATEFULSETS_NAME=()
CCXX_CRONJOBS_NAME=()
CCXX_GEODECLUSTERS_NAME=()
POD_NAMES=()

function usage() {
  cat <<EOF
  Usage:
  $(basename $0) [options]
  Script in charge of set environment variable on Kubernetes objects

  Options:
    --update-adp-deployments: set the environment variable on the configured ADP deployments
    --update-ccxx-deployments: set the environment variable on the configured CCXX deployments
    --update-adp-daemonsets: set the environment variable on the configured ADP daemonsets
    --update-ccxx-daemonsets: set the environment variable on the configured CCXX daemonsets
    --update-adp-cronjobs: set the environment variable on the configured ADP cronjobs
    --update-ccxx-cronjobs: set the environment variable on the configured CCXX cronjobs
    --update-adp-statefulsets: set the environment variable on the configured ADP statefulsets
    --update-ccxx-statefulsets: set the environment variable on the configured CCXX statefulsets
    --update-ccxx-geodeclusters: set the environment variable on the configured CCXX geodecluster CRD
    --verify: verify that environment variable is set on deployments, statefulsets, daemonsets and cronjobs
    --verify-pods: verify that environment variable is set on currrent running pods
    -n,--namespace: kubernetes namespace
    -e,--environment-variable: environment variable t oset, defaults to LOG4J_FORMAT_MSG_NO_LOOKUPS="true"
    -h,--help: Display help information
EOF
}

function parse_arguments() {
    while [ "$#" -gt 0 ]
    do
       case "$1" in
       -h|--help)
          usage
          return 0
          ;;
       --update-adp-deployments)
          UPDATE_ADP_DEPLOYMENTS=1
          ;;
       --update-ccxx-deployments)
          UPDATE_CCXX_DEPLOYMENTS=1
          ;;
       --update-adp-daemonsets)
          UPDATE_ADP_DAEMONSETS=1
          ;;
       --update-ccxx-daemonsets)
          UPDATE_CCXX_DAEMONSETS=1
          ;;
       --update-adp-cronjobs)
          UPDATE_ADP_CRONJOBS=1
          ;;
       --update-ccxx-cronjobs)
          UPDATE_CCXX_CRONJOBS=1
          ;;
       --update-adp-statefulsets)
          UPDATE_ADP_STATEFULSETS=1
          ;;
       --update-ccxx-statefulsets)
          UPDATE_CCXX_STATEFULSETS=1
          ;;
       --update-ccxx-geodeclusters)
          UPDATE_CCXX_GEODECLUSTERS=1
          ;;
       --verify)
          VERIFY=1
          ;;
       --verify-pods)
          VERIFY_PODS=1
          ;;
       -n|--namespace)
          NAMESPACE="-n ${2}"
          ;;
       -e|--environment-variable)
          ENVIRONMENT_VARIABLE=${2}
          ;;
       --)
          break
          ;;
       -*)
          echo "Invalid option '$1'. Use --help to see the valid options" >&2
          return 1
          ;;
       # an option argument, continue
       *) ;;
       esac
       shift
    done
}

function update_adp_deployments() {
  update_envs "${ADP_DEPLOYMENTS_NAME[@]}"
}

function update_ccxx_deployments() {
  update_envs "${CCXX_DEPLOYMENTS_NAME[@]}"
}

function update_adp_daemonsets() {
  update_envs "${ADP_DAEMONSETS_NAME[@]}"
}

function update_ccxx_daemonsets() {
  update_envs "${CCXX_DAEMONSETS_NAME[@]}"
}

function update_adp_cronjobs() {
  update_envs "${ADP_CRONJOBS_NAME[@]}"
}

function update_ccxx_cronjobs() {
  update_envs "${CCXX_CRONJOBS_NAME[@]}"
}

function update_adp_statefulsets() {
  update_envs "${ADP_STATEFULSETS_NAME[@]}"
}

function update_ccxx_statefulsets() {
  update_envs "${CCXX_STATEFULSETS_NAME[@]}"
}

function update_ccxx_geodeclusters() {
  patchGeodeClusters "${CCXX_GEODECLUSTERS_NAME[@]}"
}

function fetch_adp_statefulset_names() {
  for statefulset in "${ADP_MICROS[@]}"
  do
    local statefulset_name=($(kubectl get statefulsets.apps -l app.kubernetes.io/name=${statefulset} -o name ${NAMESPACE}))
    if [[ ! -z ${statefulset_name} ]]
    then
      ADP_STATEFULSETS_NAME+=("${statefulset_name[@]}")
    fi
  done
}

function fetch_ccxx_statefulset_names() {
  for statefulset in "${CCXX_MICROS[@]}"
  do
    local statefulset_name=($(kubectl get statefulsets.apps -l app.kubernetes.io/name=${statefulset} -o name ${NAMESPACE}))
    if [[ ! -z ${statefulset_name} ]]
    then
      CCXX_STATEFULSETS_NAME+=("${statefulset_name[@]}")
    fi
  done
}

function fetch_adp_deployment_names() {
  local deploymentMicros=("${@}")
  for deployment in "${ADP_MICROS[@]}"
  do
    local deployment_name=($(kubectl get deployment.apps -l app.kubernetes.io/name=${deployment} -o name ${NAMESPACE}))
    if [[ ! -z ${deployment_name} ]]
    then
      ADP_DEPLOYMENTS_NAME+=("${deployment_name[@]}")
    fi
  done
}

function fetch_ccxx_deployment_names() {
  local deploymentMicros=("${@}")
  for deployment in "${CCXX_MICROS[@]}"
  do
    local deployment_name=($(kubectl get deployment.apps -l app.kubernetes.io/name=${deployment} -o name ${NAMESPACE}))
    if [[ ! -z ${deployment_name} ]]
    then
      CCXX_DEPLOYMENTS_NAME+=("${deployment_name[@]}")
    fi
  done
}

function fetch_adp_cronjob_names() {
  for cronjob in "${ADP_MICROS[@]}"
  do
    local cronjob_name=($(kubectl get cronjobs.batch -l app.kubernetes.io/name=${cronjob} -o name ${NAMESPACE}))
    if [[ ! -z ${cronjob_name} ]]
    then
      ADP_CRONJOBS_NAME+=("${cronjob_name[@]}")
    fi
  done
}

function fetch_ccxx_cronjob_names() {
  for cronjob in "${CCXX_MICROS[@]}"
  do
    local cronjob_name=($(kubectl get cronjobs.batch -l app.kubernetes.io/name=${cronjob} -o name ${NAMESPACE}))
    if [[ ! -z ${cronjob_name} ]]
    then
      CCXX_CRONJOBS_NAME+=("${cronjob_name[@]}")
    fi
  done
}

function fetch_adp_daemonset_names() {
  for daemonset in "${ADP_MICROS[@]}"
  do
    local daemonset_name=($(kubectl get daemonset.apps -l app.kubernetes.io/name=${daemonset} -o name ${NAMESPACE}))
    if [[ ! -z ${daemonset_name} ]]
    then
      ADP_DAEMONSETS_NAME+=("${daemonset_name[@]}")
    fi
  done
}

function fetch_ccxx_daemonset_names() {
  for daemonset in "${CCXX_MICROS[@]}"
  do
    local daemonset_name=($(kubectl get daemonset.apps -l app.kubernetes.io/name=${daemonset} -o name ${NAMESPACE}))
    if [[ ! -z ${daemonset_name} ]]
    then
      CCXX_DAEMONSETS_NAME+=("${daemonset_name[@]}")
    fi
  done
}

function fetch_ccxx_geodecluster_names() {
  for geodecluster in "${CCXX_MICROS[@]}"
  do
    local geodecluster_name=($(kubectl get geodeclusters.kvdbag.data.ericsson.com -l app.kubernetes.io/name=${geodecluster} -o name ${NAMESPACE}))
    if [[ ! -z ${geodecluster_name} ]]
    then
      CCXX_GEODECLUSTERS_NAME+=("${geodecluster_name[@]}")
    fi
  done
}

function fetch_pod_names() {
  local allMicros=("${ADP_MICROS[@]}" "${CCXX_MICROS[@]}")
  for micro in "${allMicros[@]}"
  do
    local pod_name=($(kubectl get pods -l app.kubernetes.io/name=${micro} -o name ${NAMESPACE}))
    if [[ ! -z ${pod_name} ]]
    then
      POD_NAMES+=("${pod_name[@]}")
    fi
  done
}

function update_envs() {
  local elements=("${@}")
  for element in "${elements[@]}"
  do
     update_env ${element}
  done
}

function update_env() {
  local element=${1}
  echo "kubectl set env ${element} ${NAMESPACE} ${ENVIRONMENT_VARIABLE}"
  kubectl set env ${element} ${NAMESPACE} ${ENVIRONMENT_VARIABLE}
}

function verify_adp_deployments() {
  verify_envs "${ADP_DEPLOYMENTS_NAME[@]}"
}

function verify_ccxx_deployments() {
  verify_envs "${CCXX_DEPLOYMENTS_NAME[@]}"
}

function verify_adp_statefulsets() {
  verify_envs "${ADP_STATEFULSETS_NAME[@]}"
}

function verify_ccxx_statefulsets() {
  verify_envs "${CCXX_STATEFULSETS_NAME[@]}"
}

function verify_envs() {
  local elements=("${@}")
  for element in "${elements[@]}"
  do
     verify_env ${element}
  done
}

function verify_env() {
  local element=${1}
  local count=$(kubectl set env --list ${element} ${NAMESPACE} | grep -c ${ENVIRONMENT_VARIABLE})
  if [[ count -gt 0 ]]
  then
    echo "${element} is ok, there are ${count} containers with environment variable correctly set"
  else
    echo "${element} is not ok, there are no containers with environment variable correctly set"
  fi
}


function verify_pods_env() {
  for pod in "${POD_NAMES[@]}"
  do
    verify_pod_env ${pod}
  done
}

function verify_pod_env() {
  local element=${1}
  local containers=($(kubectl get ${element} ${NAMESPACE} -o jsonpath='{.spec.containers[*].name}'))
  local totalCount=0
  for container in "${containers[@]}"
  do
    local count=$(kubectl exec -it ${element} -c ${container} ${NAMESPACE} -- env | grep -c ${ENVIRONMENT_VARIABLE})
    totalCount=$((totalCount+count))
  done
  if [[ totalCount -gt 0 ]]
  then
    echo "${element} is ok, there are ${totalCount} containers with environment variable correctly set"
  else
    echo "${element} is not ok, there are no containers with environment variable correctly set"
  fi
}


function patchGeodeClusters() {
  local elements=("${@}")
  for element in "${elements[@]}"
  do
    patchGeodeCluster ${element}
  done
}

function patchGeodeCluster() {
  local geodeclusterName=${1}
  #local envVariableName=${ENVIRONMENT_VARIABLE%=*}
  #local envVariableValue=${ENVIRONMENT_VARIABLE#*=}
  kubectl patch ${geodeclusterName}  ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/adminMgr/template/spec/containers/0/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
  kubectl patch  ${geodeclusterName} ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/adminMgr/template/spec/containers/1/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
  kubectl patch ${geodeclusterName} ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/locator/template/spec/containers/0/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
  kubectl patch ${geodeclusterName} ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/locator/template/spec/containers/1/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
  kubectl patch ${geodeclusterName} ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/locator/template/spec/containers/2/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
  kubectl patch ${geodeclusterName} ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/server/template/spec/containers/0/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
  kubectl patch ${geodeclusterName} ${NAMESPACE} \
     --type='json' -p='[{"op": "add", "path": "/spec/server/template/spec/containers/1/env/-", "value":{"name":"LOG4J_FORMAT_MSG_NO_LOOKUPS","value":"true"}}]'
}

function main() {
    parse_arguments $@
    if [ $UPDATE_ADP_DEPLOYMENTS -eq 1 ]; then
      fetch_adp_deployment_names
      update_adp_deployments
    fi

    if [ $UPDATE_CCXX_DEPLOYMENTS -eq 1 ]; then
      fetch_ccxx_deployment_names
      update_ccxx_deployments
    fi

    if [ $UPDATE_ADP_DAEMONSETS -eq 1 ]; then
      fetch_adp_daemonset_names
      update_adp_daemonsets
    fi

    if [ $UPDATE_CCXX_DAEMONSETS -eq 1 ]; then
      fetch_ccxx_daemonset_names
      update_ccxx_daemonsets
    fi

    if [ $UPDATE_ADP_CRONJOBS -eq 1 ]; then
      fetch_adp_cronjob_names
      update_adp_cronjobs
    fi

    if [ $UPDATE_CCXX_CRONJOBS -eq 1 ]; then
      fetch_ccxx_cronjob_names
      update_ccxx_cronjobs
    fi

    if [ $UPDATE_ADP_STATEFULSETS -eq 1 ]; then
      fetch_adp_statefulset_names
      update_adp_statefulsets
    fi

    if [ $UPDATE_CCXX_STATEFULSETS -eq 1 ]; then
      fetch_ccxx_statefulset_names
      update_ccxx_statefulsets
    fi

    if [ $UPDATE_CCXX_GEODECLUSTERS -eq 1 ]; then
      fetch_ccxx_geodecluster_names
      update_ccxx_geodeclusters
    fi

    if [ $VERIFY -eq 1 ]; then
      fetch_adp_deployment_names
      fetch_ccxx_deployment_names
#      fetch_adp_daemonset_names
#      fetch_ccxx_daemonset_names
#      fetch_adp_cronjob_names
#      fetch_ccxx_cronjob_names
      fetch_ccxx_statefulset_names
      fetch_adp_statefulset_names
      verify_adp_deployments
      verify_ccxx_deployments
      verify_adp_statefulsets
      verify_ccxx_statefulsets
    fi

    if [ $VERIFY_PODS -eq 1 ]; then
      fetch_pod_names
      verify_pods_env
    fi
}

main $@

