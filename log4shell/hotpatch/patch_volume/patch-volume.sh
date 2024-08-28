#!/bin/bash

source "/config/adp-components.sh"
source "/config/ccxx-components.sh"
source "/config/set-env.sh"


POD_NAMES=()
PATCH_VOLUME=0
PATCH_ENV_VARIABLE=0

ADP_DEPLOYMENTS_NAME=()
ADP_DAEMONSETS_NAME=()
ADP_STATEFULSETS_NAME=()
ADP_CRONJOBS_NAME=()
CCXX_DEPLOYMENTS_NAME=()
CCXX_DAEMONSETS_NAME=()
CCXX_STATEFULSETS_NAME=()
CCXX_CRONJOBS_NAME=()
CCXX_GEODECLUSTERS_NAME=()
SKIP_LIST=("eric-udr-kvdb-ag-admin-mgr" \
           "eric-udr-kvdb-ag-locator" \
           "eric-udr-kvdb-ag-server" \
           "eric-udr-kvdb-ag-operator" \
           )

function usage() {
  cat <<EOF
  Usage:
  $(basename $0) [options]
  Adds a an empty dir volume for containers that have Java installed. Hotpatcher POD will copy
  in this volume the necessary files to patch the running program

  Options:
    -n,--namespace: kubernetes namespace
    -h,--help: Display help information
    -p,--patch-volume: Patches deployments, stastefulsets, cronjobs
       and daemonsets that are vulnerable to log4shell
    -e,--patch-env-var: Patches deployments, stastefulsets, cronjobs
       and daemonsets setting an environment variable

EOF
}

function patch_environment_variables() {
  for ((index=0; index < ${#ENV_VARIABLES[@]}; index=$((index+3)))); do
    local element="${ENV_VARIABLES[index]}"
    local variableName="${ENV_VARIABLES[index+1]}"
    local variableValue="${ENV_VARIABLES[index+2]}"
    echo "kubectl set env ${element} ${NAMESPACE} ${variableName}=${variableValue}"
    kubectl set env ${element} ${NAMESPACE} ${variableName}=${variableValue}
  done
}

function should_skip() {
  local element=${1}
  for skipElement in "${SKIP_LIST[@]}"
  do
    if [[ "${element}" == *"${skipElement}"* ]]
    then
      return 1
    fi
  done
  return 0;
}

function parse_arguments() {
    while [ "$#" -gt 0 ]
    do
       case "$1" in
       -h|--help)
          usage
          return 0
          ;;
       -p|--patch-volumes)
          PATCH_VOLUME=1
          ;;
       -e|--patch-env-var)
          PATCH_ENV_VARIABLE=1
          ;;
       -n|--namespace)
          NAMESPACE="-n ${2}"
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

function patch_ccxx_statefulset_volumes() {
  patch_volumes "${CCXX_STATEFULSETS_NAME[@]}"
}

function patch_ccxx_deployment_volumes() {
  patch_volumes "${CCXX_DEPLOYMENTS_NAME[@]}"
}

function patch_ccxx_daemonset_volumes() {
  patch_volumes "${CCXX_DAEMONSETS_NAME[@]}"
}

function patch_ccxx_cronjob_volumes() {
  patch_volumes "${CCXX_CRONJOBS_NAME[@]}"
}

function patch_adp_statefulset_volumes() {
  patch_volumes "${ADP_STATEFULSETS_NAME[@]}"
}

function patch_adp_deployment_volumes() {
  patch_volumes "${ADP_DEPLOYMENTS_NAME[@]}"
}

function patch_adp_daemonset_volumes() {
  patch_volumes "${ADP_DAEMONSETS_NAME[@]}"
}

function patch_adp_cronjob_volumes() {
  patch_volumes "${ADP_CRONJOBS_NAME[@]}"
}

function patch_volumes() {
  local elements=("${@}")
  for element in "${elements[@]}"
  do
     patch_volume ${element}
  done
}

function patch_volume() {
  local element=${1}
  should_skip "${element}"
  local skip=$?
  if [ $skip -eq 1 ]
  then
    echo "Skipping ${element}"
    return 0
  fi

  generate_patch_file ${element}
  kubectl patch ${element} ${NAMESPACE} --patch "$(cat patch-volume.yaml)"
  rm patch-volume.yaml
  rm values.yaml
}

function generate_patch_file() {
  local element=${1}
  # For cronjobs is .spec.jobTemplate.spec.template.spec.containers[*].name
  local containers=($(kubectl get ${element} ${NAMESPACE} -o jsonpath='{.spec.template.spec.containers[*].name}'))
  echo "containerNames:" > values.yaml
  for container in "${containers[@]}"
  do
    is_java_container ${element} ${container}
    local is_java=$?
    if [ ${is_java} -eq 0 ]
    then
      echo "  - ${container}" >> values.yaml
    fi
  done

  ./render_template patch-volume.tmpl values.yaml > patch-volume.yaml
}

function is_java_container() {
  local element=${1}
  local containers=${2}
  local ret
  kubectl exec -it ${element} -c ${container} ${NAMESPACE} -- bash -c 'which java && java -version'
  ret=$?
  if [[ $ret -eq 0 ]]
  then
     return 0
  fi
  return 1
}


function patch_geodecluster() {
  kubectl patch geodeclusters.kvdbag.data.ericsson.com eric-udr-kvdb-ag ${NAMESPACE} --type='json' \
     -p='[{"op": "add", "path": "/spec/locator/template/spec/volumes/-", "value":   {"emptyDir": {}, "name": "log4shell-eric-udr-kvdb-ag-locator-monitor"} }]'
  kubectl patch geodeclusters.kvdbag.data.ericsson.com eric-udr-kvdb-ag ${NAMESPACE} --type='json' \
     -p='[{"op": "add", "path": "/spec/locator/template/spec/volumes/-", "value":   {"emptyDir": {}, "name": "log4shell-eric-udr-kvdb-ag-locator-jmx-exporter"} }]'
  kubectl patch geodeclusters.kvdbag.data.ericsson.com eric-udr-kvdb-ag ${NAMESPACE} --type='json' \
     -p='[{"op": "add", "path": "/spec/locator/template/spec/containers/1/volumeMounts/-", "value": {"mountPath": "/tmp", "name": "log4shell-eric-udr-kvdb-ag-locator-monitor"} }]'
  kubectl patch geodeclusters.kvdbag.data.ericsson.com eric-udr-kvdb-ag ${NAMESPACE} --type='json' \
     -p='[{"op": "add", "path": "/spec/locator/template/spec/containers/2/volumeMounts/-", "value": {"mountPath": "/tmp", "name": "log4shell-eric-udr-kvdb-ag-locator-jmx-exporter"} }]'
  kubectl patch geodeclusters.kvdbag.data.ericsson.com eric-udr-kvdb-ag ${NAMESPACE} --type='json' \
     -p='[{"op": "add", "path": "/spec/server/template/spec/volumes/-", "value":   {"emptyDir": {}, "name": "log4shell-eric-udr-kvdb-ag-server-monitor"} }]'
  kubectl patch geodeclusters.kvdbag.data.ericsson.com eric-udr-kvdb-ag ${NAMESPACE} --type='json' \
     -p='[{"op": "add", "path": "/spec/server/template/spec/containers/1/volumeMounts/-", "value": {"mountPath": "/tmp", "name": "log4shell-eric-udr-kvdb-ag-server-monitor"} }]'
}

function main() {
    parse_arguments $@
    if [ $PATCH_ENV_VARIABLE -eq 1 ]; then
      patch_environment_variables
    fi
    if [ $PATCH_VOLUME -eq 1 ]; then
      patch_geodecluster
      fetch_ccxx_statefulset_names
      patch_ccxx_statefulset_volumes
      fetch_adp_statefulset_names
      patch_adp_statefulset_volumes
      fetch_ccxx_deployment_names
      patch_ccxx_deployment_volumes
      fetch_adp_deployment_names
      patch_adp_deployment_volumes
      fetch_ccxx_daemonset_names
      patch_ccxx_daemonset_volumes
      fetch_adp_daemonset_names
      patch_adp_daemonset_volumes
      fetch_ccxx_cronjob_names
      patch_ccxx_cronjob_volumes
      fetch_adp_cronjob_names
      patch_adp_cronjob_volumes
    fi
}

main $@

