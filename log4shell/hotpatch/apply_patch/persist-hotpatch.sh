#!/bin/bash


source "/config/adp-components.sh"
source "/config/ccxx-components.sh"


POD_NAMES=()
HOTPATCH_PODS=0
SHARED_DIR=/tmp

function usage() {
  cat <<EOF
  Usage:
  $(basename $0) [options]
  Script that monitors for vulnerable Java PODs and applies a hotpatch

  Options:
    -n,--namespace: kubernetes namespace
    -h,--help: Display help information
    -n,--namespace: kubernetes namespace
    -p,--hotpatch-pods: patches list of vulnerable PODs given in a passed list
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
       -p|--hotpatch-pods)
          HOTPATCH_PODS=1
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

function fetch_pod_names() {
  POD_NAMES=()
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

function hotpatch_pods() {
  for pod in "${POD_NAMES[@]}"
  do
    hotpatch_pod ${pod}
  done
}

function hotpatch_pod() {
  local element=${1}
  local containers=($(kubectl get ${element} ${NAMESPACE} -o jsonpath='{.spec.containers[*].name}'))
  for container in "${containers[@]}"
  do
    local java_ver
    java_ver=$(set -o pipefail; kubectl exec -it ${element} -c ${container}  ${NAMESPACE} -- bash -c  \
             'java -version 2>&1' | awk -F'"' '/version/ {print $2}')
    local ret=$?
    if [[ $ret -eq 0 ]]
    then
      hotpatch_container ${element} ${container} ${java_ver}
    fi
  done
}

function hotpatch_container() {
  local element=${1}
  local container=${2}
  local javaver=${3}
  local pod_name=${element#*/}
  kubectl cp Log4jHotPatch.jar ${pod_name}:${SHARED_DIR}/Log4jHotPatch.jar -c ${container} ${NAMESPACE}
  echo "Hotpatching ${element} in container ${container} (java ${javaver})"
  if [[ "${javaver}" =~ 1\.8(\..*)*$ ]]
  then
    kubectl cp jdk8/libattach.so ${pod_name}:${SHARED_DIR}/libattach.so -c ${container} ${NAMESPACE}
    kubectl cp jdk8/tools.jar ${pod_name}:${SHARED_DIR}/tools.jar -c ${container} ${NAMESPACE}
    # Command in Java 8: java -cp <java-home>/lib/tools.jar:Log4jHotPatch.jar Log4jHotPatch <java-pid>
    kubectl exec -it ${element} -c ${container} ${NAMESPACE} -- bash -c \
    'export LD_LIBRARY_PATH='"${SHARED_DIR}"'; for pid in $(ps -C "java" -o pid=); do java -cp '"${SHARED_DIR}"'/tools.jar:'"${SHARED_DIR}"'/Log4jHotPatch.jar Log4jHotPatch ${pid}; done'
  else
    kubectl cp jdk11/libattach.so ${pod_name}:${SHARED_DIR}/libattach.so -c ${container} ${NAMESPACE}
    # Command in Java 11 and up: java -jar Log4jHotPatch.jar <java-pid>
    kubectl exec -it ${element} -c ${container} ${NAMESPACE} -- bash -c \
    'export LD_LIBRARY_PATH='"${SHARED_DIR}"'; for pid in $(ps -C "java" -o pid=); do java -jar '"${SHARED_DIR}"'/Log4jHotPatch.jar ${pid}; done'
  fi
}

function main() {
    parse_arguments $@
    if [ $HOTPATCH_PODS -eq 1 ]; then
      sleep 120
      while true
      do
        fetch_pod_names
        hotpatch_pods
        sleep 600
      done
    fi
}

main $@

