#!/bin/bash
#helm repo update
BLUE="\e[44m"
YELLOW="\e[33m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

adp_requirements=$HOME/git/integration/eric-adp-5g-udm/helm/requirements.yaml
sm_requirements=$HOME/git/integration-service-mesh/eric-udm-mesh-integration/requirements.yaml

serviceNames=(eric-data-document-database-pg eric-cm-mediator eric-pm-server eric-pm-bulk-reporter eric-data-coordinator-zk eric-data-message-bus-kf eric-log-shipper eric-data-search-engine eric-fh-alarm-handler eric-fh-snmp-alarm-provider eric-cm-yang-provider eric-data-search-engine-curator eric-odca-diagnostic-data-collector eric-log-transformer eric-ctrl-bro eric-sec-access-mgmt eric-sec-ldap-server eric-sec-key-management eric-sec-sip-tls eric-data-distributed-coordinator-ed eric-cnom-server eric-tm-ingress-controller-cr eric-lm-combined-server eric-sec-certm eric-lm-unique-object-reporter eric-sec-admin-user-management eric-data-object-storage-mn eric-si-application-sys-info-handler eric-pm-resource-monitor eric-dst-collector eric-dst-query eric-probe-virtual-tap-broker)
smService=eric-mesh-controller

praCounter=false

echo -e "\nChecking latest PRA versions in ADP common:\n"
for serviceName in ${serviceNames[@]}; do
  #echo "---------------------------------------------"
  #echo ${serviceName}

  if [ $serviceName == "eric-cnom-server" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-pc-rs-released-helm/eric-cnom-server/
  elif [ $serviceName == "eric-lm-unique-object-reporter" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-eric-unique-object-reporter-released-helm/eric-lm-unique-object-reporter/
  elif [ $serviceName == "eric-lm-combined-server" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-gs-released-helm/eric-lm-combined-server/
  elif [ $serviceName == "eric-dst-collector" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-gs-released-helm/eric-dst-collector/
  elif [ $serviceName == "eric-dst-query" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-gs-released-helm/eric-dst-query/
  elif [ $serviceName == "eric-data-object-storage-mn" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-eric-data-object-storage-mn-released-helm/eric-data-object-storage-mn/
  elif [ $serviceName == "eric-si-application-sys-info-handler" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-eric-application-sys-info-handler-released-helm-local/eric-si-application-sys-info-handler/
  elif [ $serviceName == "eric-pm-resource-monitor" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-pc-released-helm/eric-pm-resource-monitor/
  elif [ $serviceName == "eric-probe-virtual-tap-broker" ]; then
    repo=https://arm.sero.gic.ericsson.se/artifactory/proj-pc-released-helm/eric-probe-virtual-tap-broker/
  else
    repo=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-released-helm/${serviceName}/
  fi

  # echo "Repo is: ${repo}"
  if [ ${repo} == "https://arm.sero.gic.ericsson.se/artifactory/proj-adp-eric-unique-object-reporter-released-helm/eric-lm-unique-object-reporter/" ]; then
    latestVersion=$(curl -sS -k -L ${repo} -u esdccci:Pcdlcci1 | sed 's/<.*">//' | sed "s/\([0-9]\{2\}\)-\(.\{3\}\)-\([0-9]\{4\}\)/\1 \2 \3/" | grep -v "eric-lm-unique-object-reporter/" | sort -k4n -k3M -k2n | tail -n1 | sed -e 's/<\/a>//' | awk '{print $1}' | grep -E -o "[0-9.]+\+[0-9]+")
  else
    latestVersion=$(curl -sS -k -L ${repo} -u esdccci:Pcdlcci1 | sed 's/<.*">//' | sed "s/\([0-9]\{2\}\)-\(.\{3\}\)-\([0-9]\{4\}\)/\1 \2 \3/" | sort -k4n -k3M -k2n | tail -n1 | sed -e 's/<\/a>//' | awk '{print $1}' | grep -E -o "[0-9.]+\+[0-9]+")
  fi

  #echo "Latest version for $serviceName is ${latestVersion}"

  currentVersion=$(cat $adp_requirements | grep ${serviceName} -A1 | grep version | grep -v '#' | awk '{print $2}' | head -1)
  #echo "Current version for ${serviceName} is: ${currentVersion}"

  if [ ${currentVersion} != ${latestVersion} ]; then
    echo "----------------------------------------------------------------------------------------------"
    echo -e "There is new version for ${BLUE}${serviceName}${ENDCOLOR}: ${GREEN}${latestVersion}${ENDCOLOR}, current is: ${YELLOW}${currentVersion}${ENDCOLOR}"
    praCounter=true
  fi

done
if [ "${praCounter}" == 'false' ]; then
  echo "----------------------------------------------------------------------------------------------"
  echo "There are no new PRA versions."
fi
echo "----------------------------------------------------------------------------------------------"

echo -e "\nChecking latest PRA version for SM:\n"
repo=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-released-helm/${smService}/
latestVersion=$(curl -sS -k -L ${repo} -u esdccci:Pcdlcci1 | sed 's/<.*">//' | sed "s/\([0-9]\{2\}\)-\(.\{3\}\)-\([0-9]\{4\}\)/\1 \2 \3/" | sort -k4n -k3M -k2n | tail -n1 | sed -e 's/<\/a>//' | awk '{print $1}' | grep -E -o "[0-9.]+\+[0-9]+")
currentVersion=$(cat $sm_requirements | grep ${smService} -A1 | grep version | grep -v '#' | awk '{print $2}' | head -1)
if [ ${currentVersion} != ${latestVersion} ]; then
  echo "----------------------------------------------------------------------------------------------"
  echo -e "There is new version for ${BLUE}${smService}${ENDCOLOR}: ${GREEN}${latestVersion}${ENDCOLOR}, current is: ${YELLOW}${currentVersion}${ENDCOLOR}"
  echo "----------------------------------------------------------------------------------------------"
else
  echo "----------------------------------------------------------------------------------------------"
  echo "There is no new PRA version."
  echo "----------------------------------------------------------------------------------------------"
fi

echo -e "\nSuccessfully done!\n"
