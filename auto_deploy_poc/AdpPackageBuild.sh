#!/bin/bash
#helm repo update

#-------------------------------------------------------------------------------------------------------

BLUE="\e[44m"
YELLOW="\e[33m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"


function checkAnalysis {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "${serviceName} ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "${serviceName} ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisPMBR {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "PM Bulk Reporter ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "Pm Bulk Reporter ${a}.${b}" | wc -l)
      doesExist3=$(echo ${curlRes} | grep "PM Bulk Reporter ${c}.0" | wc -l)
      doesExist4=$(echo ${curlRes} | grep "Pm Bulk Reporter ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] && [ ${doesExist4} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisSkippedVersion {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))
      d=$((${j}+2))

      doesExist1=$(echo ${curlRes} | grep "${serviceName} ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "${serviceName} ${a}.${d}" | wc -l)
      doesExist3=$(echo ${curlRes} | grep "${serviceName} ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisPMResource {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    if [ ${i} -eq 1 ]; then
      for j in {7..30}; do
        a=${i}
        b=$((${j}+1))
        c=$((${i}+1))
        d=$((${j}+2))

        doesExist1=$(echo ${curlRes} | grep "${serviceName} ${a}.${b}" | wc -l)
        doesExist2=$(echo ${curlRes} | grep "${serviceName} ${a}.${d}" | wc -l)
        doesExist3=$(echo ${curlRes} | grep "${serviceName} ${c}.0" | wc -l)

        if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
            continue
        elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] ; then
            lastversion=${i}.${j}.0
            echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
            break 2
        elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
            break
        fi
      done
    else
      for j in {0..30}; do
        a=${i}
        b=$((${j}+1))
        c=$((${i}+1))
        d=$((${j}+2))

        doesExist1=$(echo ${curlRes} | grep "${serviceName} ${a}.${b}" | wc -l)
        doesExist2=$(echo ${curlRes} | grep "${serviceName} ${a}.${d}" | wc -l)
        doesExist3=$(echo ${curlRes} | grep "${serviceName} ${c}.0" | wc -l)

        if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
            continue
        elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] ; then
            lastversion=${i}.${j}.0
            echo "----------------------------------------------------------------------------"
            echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
            break 2
        elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
            break
        fi
      done
    fi
  done
}
function checkAnalysisAUM {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "${serviceName} ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "${serviceName}, ${a}.${b}" | wc -l)
      doesExist3=$(echo ${curlRes} | grep "${serviceName} ${c}.0" | wc -l)
      doesExist4=$(echo ${curlRes} | grep "${serviceName}, ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] && [ ${doesExist4} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisZK {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "Data Coordinator ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "Data Coordinator ZK ${a}.${b}" | wc -l)
      doesExist3=$(echo ${curlRes} | grep "Data Coordinator ${c}.0" | wc -l)
      doesExist4=$(echo ${curlRes} | grep "Data Coordinator ZK ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] && [ ${doesExist4} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisPMServer {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "PM Server ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "PM server ${a}.${b}" | wc -l)
      doesExist3=$(echo ${curlRes} | grep "PM Server ${c}.0" | wc -l)
      doesExist4=$(echo ${curlRes} | grep "PM server ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] && [ ${doesExist4} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisSHH {
  # This is the same as checkAnalysis function, but it's starting from 2.12.0 and not from 2.0.0 as other analysis so that's why I created separate function
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {11..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "${serviceName} ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "${serviceName} ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        echo "Please, check for 3.0.0 and then change finding in script..!!"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -ne 0 ] ; then
        break
      fi

    done
  done
}

function checkAnalysisMBKF {
  local link=$1
  local serviceName=$2
  local startNum=$3
  local endNum=$4

  curlRes=$(curl -sS -k -L ${link} -u esdccci:Pcdlcci1)

  for ((i=${startNum}; i<${endNum}; i++)); do
    for j in {0..30}; do

      a=${i}
      b=$((${j}+1))
      c=$((${i}+1))

      doesExist1=$(echo ${curlRes} | grep "Message Bus ${a}.${b}" | wc -l)
      doesExist2=$(echo ${curlRes} | grep "ADP Message Bus KF ${a}.${b}" | wc -l)
      doesExist3=$(echo ${curlRes} | grep "Message Bus ${c}.0" | wc -l)
      doesExist4=$(echo ${curlRes} | grep "ADP Message Bus KF ${c}.0" | wc -l)

      if [ ${doesExist1} -ne 0 ] || [ ${doesExist2} -ne 0 ]; then
        continue
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist2} -eq 0 ] && [ ${doesExist3} -eq 0 ] && [ ${doesExist4} -eq 0 ] ; then
        lastversion=${i}.${j}.0
        echo -e "Latest analysis for ${BLUE}${serviceName}${ENDCOLOR} is ${GREEN}${lastversion}${ENDCOLOR}, you can find it on link ${YELLOW}${link}${ENDCOLOR}"
        break 2
      elif [ ${doesExist1} -eq 0 ] && [ ${doesExist3} -ne 0 ] ; then
        break
      fi

    done
  done
}

function findLatestMain {

  local serviceName=$1

   ERICDATADOCUMENTDATABASEPGLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105711?jql=labels%20%3D%20DocumentDatabase
   ERICCMMEDIATORLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106552?jql=labels%20%3D%20CMMediator
   ERICPMSERVERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105935?jql=labels%20%3D%20PMServer
   ERICPMBLUKREPORTERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105929?jql=labels%20%3D%20PMBulkReporter
   ERICDATACOORDINATORZKLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106551?jql=labels%20%3D%20DataCoordinatorZK
   ERICDATAMESSAGEBUSKFLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106535?jql=labels%20%3D%20MessageBus
   ERICLOGSHIPPERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106779?jql=labels%20%3D%20LogShipper
   ERICDATASEARCHENGINELINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106349?jql=labels%20%3D%20SearchEngine
   ERICFHALARMHANDLERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106567?jql=labels%20%3D%20AlarmHandler
   ERICFHSNMPALARMPROVIDERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106570?jql=labels%20%3D%20SNMPAlarmProvider
   ERICCMYPLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106549?jql=labels%20%3D%20CMYangProvider
   ERICDATASEARCHENGINECURATORLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-86145?jql=labels%20%3D%20SearchEngineCurator
   ERICODCALINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105923?jql=labels%20%3D%20DDC
   ERICLOGTRANSFORMERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106782?jql=labels%20%3D%20LogTransformer
   ERICBROLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106784?jql=labels%20%3D%20%22Backup%26Restore%22
   ERICSECACCESMGMTLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105016?jql=labels%20%3D%20IAM
   ERICLDAPLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106247?jql=labels%20%3D%20LDAP-Server
   ERICSECKEYMGMTLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106616?jql=labels%20%3D%20KMS
   ERICSIPTLSLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106034?jql=labels%20%3D%20sip-tls
   ERICDCEDLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106525?jql=labels%20%3D%20DCED
   ERICCNOMSERVERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105738?jql=labels%20%3D%20CNOMServer
   ERICTMICCRLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-104616?jql=labels%20%3D%20ICCR
   ERICLMCOMBINEDSERVERLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106638?jql=labels%20%3D%20LicenseManager
   ERICSECCERTMLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106622?jql=labels%20%3D%20Cert-Mgmt
   ERICUORLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-103721?jql=labels%20%3D%20UOR
   ERICSECADMINUSERMGMTLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106357?jql=labels%20%3D%20AUM
   ERICOSMNLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-105500?jql=labels%20%3D%20DataServices
   ERICASIHLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106201?jql=labels%20%3D%20ASIH
   ERICPMRESOURCEMONITORLINK=https://eteamproject.internal.ericsson.com/browse/UDM5GP-84537?jql=labels%20%3D%20PMResourceMonitor
   ERICPROBEVIRTUALTAPBROKER=https://eteamproject.internal.ericsson.com/browse/UDM5GP-86179?jql=labels%20%3D%20PVTB
   SMARTHELMHOOKS=https://eteamproject.internal.ericsson.com/browse/UDM5GP-106558?jql=labels%20%3D%20SHH

  if [ ${serviceName} == "eric-data-document-database-pg" ]; then
    checkAnalysis ${ERICDATADOCUMENTDATABASEPGLINK} "Document Database" 9 20
  elif [ ${serviceName} == "eric-cm-mediator" ]; then
    checkAnalysis ${ERICCMMEDIATORLINK} "CM Mediator" 10 20
  elif [ ${serviceName} == "eric-pm-server" ]; then
    checkAnalysisPMServer ${ERICPMSERVERLINK} "PM Server" 13 40
  elif [ ${serviceName} == "eric-pm-bulk-reporter" ]; then
    checkAnalysisPMBR ${ERICPMBLUKREPORTERLINK} "PM Bulk Reporter" 11 30 
  elif [ ${serviceName} == "eric-data-coordinator-zk" ]; then
    checkAnalysisZK ${ERICDATACOORDINATORZKLINK} "Data Coordinator" 3 50
  elif [ ${serviceName} == "eric-data-message-bus-kf" ]; then
    checkAnalysisMBKF ${ERICDATAMESSAGEBUSKFLINK} "Message Bus" 2 40
  elif [ ${serviceName} == "eric-log-shipper" ]; then
    checkAnalysis ${ERICLOGSHIPPERLINK} "Log Shipper" 19 20
  elif [ ${serviceName} == "eric-data-search-engine" ]; then
    checkAnalysis ${ERICDATASEARCHENGINELINK} "Search Engine" 14 30
  elif [ ${serviceName} == "eric-fh-alarm-handler" ]; then
    checkAnalysis ${ERICFHALARMHANDLERLINK} "Alarm Handler" 17 30
  elif [ ${serviceName} == "eric-fh-snmp-alarm-provider" ]; then
    checkAnalysis ${ERICFHSNMPALARMPROVIDERLINK} "SNMP Alarm Provider" 12 30
  elif [ ${serviceName} == "eric-cm-yang-provider" ]; then
    checkAnalysis ${ERICCMYPLINK} "CM Yang Provider" 21 30
  elif [ ${serviceName} == "eric-data-search-engine-curator" ]; then
    checkAnalysis ${ERICDATASEARCHENGINECURATORLINK} "Search Engine Curator" 3 30
  elif [ ${serviceName} == "eric-odca-diagnostic-data-collector" ]; then
    checkAnalysis ${ERICODCALINK} "Diagnostic Data Collector" 10 40
  elif [ ${serviceName} == "eric-log-transformer" ]; then
    checkAnalysis ${ERICLOGTRANSFORMERLINK} "Log Transformer" 17 40
  elif [ ${serviceName} == "eric-ctrl-bro" ]; then
    checkAnalysis ${ERICBROLINK} "Backup and Restore Orchestrator" 10 40
  elif [ ${serviceName} == "eric-sec-access-mgmt" ]; then
    checkAnalysisSkippedVersion ${ERICSECACCESMGMTLINK} "IAM" 21 40
  elif [ ${serviceName} == "eric-sec-ldap-server" ]; then
    checkAnalysis ${ERICLDAPLINK} "LDAP server" 12 40
  elif [ ${serviceName} == "eric-sec-key-management" ]; then
    checkAnalysis ${ERICSECKEYMGMTLINK} "Key Management" 8 40
  elif [ ${serviceName} == "eric-sec-sip-tls" ]; then
    checkAnalysis ${ERICSIPTLSLINK} "Service Identity Provider TLS (SIP-TLS)" 11 40
  elif [ ${serviceName} == "eric-data-distributed-coordinator-ed" ]; then
    checkAnalysisSkippedVersion ${ERICDCEDLINK} "DCED" 10 40
  elif [ ${serviceName} == "eric-cnom-server" ]; then
    echo -e "TRAZENJE VERZIJE NIJE NAPRAVLJENO, ZADNJU ANALIZU PROVJERIT NA LINKU: ${YELLOW}${ERICCNOMSERVERLINK}${ENDCOLOR}"
  elif [ ${serviceName} == "eric-tm-ingress-controller-cr" ]; then
    checkAnalysis ${ERICTMICCRLINK} "Ingress Controller CR" 15 40
  elif [ ${serviceName} == "eric-lm-combined-server" ]; then
    checkAnalysis ${ERICLMCOMBINEDSERVERLINK} "License Manager" 9 40
  elif [ ${serviceName} == "eric-sec-certm" ]; then
    checkAnalysis ${ERICSECCERTMLINK} "Certificate Management" 10 50
  elif [ ${serviceName} == "eric-lm-unique-object-reporter" ]; then
    checkAnalysisSkippedVersion ${ERICUORLINK} "Unique Object Reporter" 4 50
  elif [ ${serviceName} == "eric-sec-admin-user-management" ]; then
    checkAnalysisAUM ${ERICSECADMINUSERMGMTLINK} "Admin User Management" 5 50
  elif [ ${serviceName} == "eric-data-object-storage-mn" ]; then
    checkAnalysisSkippedVersion ${ERICOSMNLINK} "Object Storage" 2 50
  elif [ ${serviceName} == "eric-si-application-sys-info-handler" ]; then
    checkAnalysis ${ERICASIHLINK} "Application Sys Info Handler" 2 50
  elif [ ${serviceName} == "eric-pm-resource-monitor" ]; then
    checkAnalysisPMResource ${ERICPMRESOURCEMONITORLINK} "PM Resource Monitor" 1 50
  elif [ ${serviceName} == "eric-probe-virtual-tap-broker" ]; then
    checkAnalysis ${ERICPROBEVIRTUALTAPBROKER} "PVTB" 4 50
  elif [ ${serviceName} == "eric-lcm-smart-helm-hooks" ]; then
    checkAnalysisSHH ${SMARTHELMHOOKS} "Smart Helm Hooks" 2 50
  fi

}

function printLatestVersionsAndAnalysis {
#-------------------------------------------------------------------------------------------------------

  adp_requirements=$HOME/git/integration/eric-adp-5g-udm/helm/requirements.yaml
  sm_requirements=$HOME/git/integration-service-mesh/eric-udm-mesh-integration/requirements.yaml

  serviceNames=(eric-data-document-database-pg eric-cm-mediator eric-pm-server eric-pm-bulk-reporter eric-data-coordinator-zk eric-data-message-bus-kf eric-log-shipper eric-data-search-engine eric-fh-alarm-handler eric-fh-snmp-alarm-provider eric-cm-yang-provider eric-data-search-engine-curator eric-odca-diagnostic-data-collector eric-log-transformer eric-ctrl-bro eric-sec-access-mgmt eric-sec-ldap-server eric-sec-key-management eric-sec-sip-tls eric-data-distributed-coordinator-ed eric-cnom-server eric-tm-ingress-controller-cr eric-lm-combined-server eric-sec-certm eric-lm-unique-object-reporter eric-sec-admin-user-management eric-data-object-storage-mn eric-si-application-sys-info-handler eric-pm-resource-monitor eric-dst-collector eric-dst-query eric-probe-virtual-tap-broker eric-lcm-smart-helm-hooks)
  smService=eric-mesh-controller

  praCounter=false

  echo -e "\nChecking latest PRA versions and analysis in ADP common:\n"
  for serviceName in ${serviceNames[@]}; do

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
    elif [ $serviceName == "eric-si-application-sys-info-handler" ]; then
      repo=https://arm.sero.gic.ericsson.se/artifactory/proj-adp-eric-application-sys-info-handler-released-helm-local/eric-si-application-sys-info-handler/
    elif [ $serviceName == "eric-pm-resource-monitor" ]; then
      repo=https://arm.sero.gic.ericsson.se/artifactory/proj-pc-released-helm/eric-pm-resource-monitor/
    elif [ $serviceName == "eric-probe-virtual-tap-broker" ]; then
      repo=https://arm.sero.gic.ericsson.se/artifactory/proj-pc-released-helm/eric-probe-virtual-tap-broker/
    else
      repo=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-released-helm/${serviceName}/
    fi

    if [ ${repo} == "https://arm.sero.gic.ericsson.se/artifactory/proj-adp-eric-unique-object-reporter-released-helm/eric-lm-unique-object-reporter/" ]; then
      latestVersion=$(curl -sS -k -L ${repo} -u esdccci:Pcdlcci1 | sed 's/<.*">//' | sed "s/\([0-9]\{2\}\)-\(.\{3\}\)-\([0-9]\{4\}\)/\1 \2 \3/" | grep -v "eric-lm-unique-object-reporter/" | sort -k4n -k3M -k2n | tail -n1 | sed -e 's/<\/a>//' | awk '{print $1}' | grep -E -o "[0-9.]+\+[0-9]+")
    else
      latestVersion=$(curl -sS -k -L ${repo} -u esdccci:Pcdlcci1 | sed 's/<.*">//' | sed "s/\([0-9]\{2\}\)-\(.\{3\}\)-\([0-9]\{4\}\)/\1 \2 \3/" | sort -k4n -k3M -k2n | tail -n1 | sed -e 's/<\/a>//' | awk '{print $1}' | grep -E -o "[0-9.]+\+[0-9]+")
    fi

    currentVersion=$(cat $adp_requirements | grep ${serviceName} -A1 | grep version | grep -v '#' | awk '{print $2}' | head -1)

    if [ ${currentVersion} != ${latestVersion} ]; then
      echo "----------------------------------------------------------------------------------------------"
      echo "----------------------------------------------------------------------------------------------"
      echo -e "There is new version for ${BLUE}${serviceName}${ENDCOLOR}: ${GREEN}${latestVersion}${ENDCOLOR}, current is: ${YELLOW}${currentVersion}${ENDCOLOR}"
      echo ""
      findLatestMain ${serviceName}
      praCounter=true
    fi

  done
  if [ "${praCounter}" == 'false' ]; then
    echo "----------------------------------------------------------------------------------------------"
    echo "There are no new PRA versions."
  fi
  echo "----------------------------------------------------------------------------------------------"
  echo "----------------------------------------------------------------------------------------------"
  echo ""
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

  echo "Links to check last analysis for SM:"
  echo -e "On confluence: ${YELLOW}https://eteamspace.internal.ericsson.com/display/PUPDF/ADP+Service+Mesh+12.3.0${ENDCOLOR}"
  echo -e "In JIRA: ${YELLOW}https://eteamproject.internal.ericsson.com/browse/CCES-70161?jql=text%20~%20%22Mesh%22${ENDCOLOR}"

  echo -e "\nSuccessfully done!\n"
}


main() {
  printLatestVersionsAndAnalysis
}

main