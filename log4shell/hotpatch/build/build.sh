#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${SCRIPT_DIR}/..
VERSION_APPLY_PATCH=$(cat apply_patch/VERSION)
VERSION_PATCH_VOLUME=$(cat patch_volume/VERSION)

function main() {
  mkdir -p artifacts
  cp charts/values.yaml values_original.yaml
  sed -i -e "s|%VERSION_APPLY_PATCH%|${VERSION_APPLY_PATCH}|g" \
         -e "s|%VERSION_PATCH_VOLUME%|${VERSION_PATCH_VOLUME}|g"\
      charts/values.yaml
  helm package  -d artifacts charts
  mv values_original.yaml charts/values.yaml
  docker build -t sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/eric-log4shell-hotpatch-init:${VERSION_PATCH_VOLUME} patch_volume
  docker build -t sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/eric-log4shell-hotpatch:${VERSION_APPLY_PATCH} apply_patch
  docker save sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/eric-log4shell-hotpatch-init:${VERSION_PATCH_VOLUME} \
     -o artifacts/docker-eric-log4shell-hotpatch-init-${VERSION_PATCH_VOLUME}.tar
  docker save sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/eric-log4shell-hotpatch:${VERSION_APPLY_PATCH} \
     -o artifacts/docker-eric-log4shell-hotpatch-${VERSION_APPLY_PATCH}.tar
  tar cvfz log4shell-hotpatch.tar.gz artifacts/
  rm -rf artifacts/
}

main @