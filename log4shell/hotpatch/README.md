# How to build
Locate in *log4shell/hotpatch* directory and execute

 ---
 build/build.sh
 ---

It will generate a tar ball file named *log4shell-hotpatch.tar.gz*

# How to deploy

Extract the tar ball file

 ---
 tar xvzf log4shell-hotpatch.tar.gz
 ---

It contains two docker images and a helm chart. First of all, upload the docker images to your docker registry

 ---
 docker load -i YOUR_DOCKER_TAR
 docker images (look for your image you just loaded)
 docker tag IMAGE:TAG REPO_URL:PORT/IMAGE:TAG (e.g docker tag sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/eric-log4shell-hotpatch:1.3.0 127.0.0.1:5000/eric-log4shell-hotpatch:1.3.0)
 docker push REPO_URL:PORT/IMAGE:TAG
 ---

Install the helm chart

 ---
 helm install eric-log4shell artifacts/eric-log4shell-hotpatch-1.0.0.tgz $namespace
 ---
You can override default value of variables of *global.registry.url* and *imageCredentials.repoPath*

For instance

 ---
 helm install eric-log4shell --set global.registry.url=<your docker registry URL> --set mageCredentials.repoPath=<your repo path> artifacts/eric-log4shell-hotpatch-1.0.0.tgz $namespace
 ---


# Setps

## Create RBAC rules
Necessary role, rolebindings and user account are created for the hotpatch POD

## Patch affected microservices to mount /tmp on an empty_dir volume
This volume is needed to copy the hotpatch jar file and the shared library to attach to Java process. Also, when attaching the agent needs to write a file to */tmp* directory. It cannot be copied to the container filesystem because some containers mount filesystem as readonly due to security reasons
The script programatically searches vulnerable PODs iterating in the given list and for containers with Java process running adds *volume* and *volumeMounts* in the *deployment*, *statefulset*, *daemonsets* or *cronjobs*

## Deploy helm patch with hotpatch image
Image that actually runs the hotpatch can de deployed as a Kubernetes deployment or cronjob. The script must run periodically to find new PODs thast must be patched. The hotpatch is idempotent, if a Java process is patched it will do nothing else than log that is already patched. On one hand the process to iterate over all running PODs and patch them, can consume many resources if it is run very frequently, on the other hand if the period is long new created PODs can be unprotected more time.

# Improvement
Set a watcher on Kubernetes API for vulnerable PODs and whenever a new vulnerable POD is created, call the script to patch only the given POD





