
# How to Helm Ericsson __ADP Generic Services__

## 1. Add the ADP-GS Helm repository

Add the Virtual Helm Repository:

```
helm repo add arm-adp-eric-gs-all-helm https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-all-helm

helm repo update
```

## 2. Clone the integration git repository

Gerrit: https://gerrit-gamma-read.seli.gic.ericsson.se/#/admin/projects/5gcicd/integration

```
mkdir -p $HOME/git/5gcicd && cd $HOME/git/5gcicd
git clone ssh://$USER@gerrit-gamma-read.seli.gic.ericsson.se:29418/5gcicd/integration
```

## 3. Create simbolic link (in your git home directory)

Because the templates are stored in "helm" subdirectory:

```
cd $HOME/git
ln -s 5gcicd/integration/eric-adp-5g-udm/helm eric-adp-5g-udm
```

Directory will look like:
```
~/git$ ll
total 0
drwxrwxrwx 0 user user 512 5gcicd
lrwxrwxrwx 1 user user  39 eric-adp-5g-udm -> 5gcicd/integration/eric-adp-5g-udm/helm

```

## 4. Edit with custom values and requirements

Example:

```
vi eric-adp-5g-udm/values.yaml
vi eric-adp-5g-udm/requirements.yaml
```

## 5. Generate Helm Package

```
cd $HOME/git
helm lint eric-adp-5g-udm
## First manually update dependency for service-mesh-integration helm chart
helm dependency update local_charts/eric-mesh-integration
helm package --dependency-update eric-adp-5g-udm
```

Notice the default location to write the chart. (default ".")

## 6. Try Helm package (dry-run and debug modes)

Example installs eric-data-message-bus-kf with custom PersistentVolumeClaim value.

```
helm install eric-adp-5g-udm-<VERSION>.tgz --name eric-adp-5g-udm \
--set tags.eric-data-message-bus-kf=true \
--set eric-data-message-bus-kf.persistentVolumeClaim.storageClassName=default \
--debug --dry-run
```

## 7. Upgrade already deployed helm chart from version X to Y

Notice that upgrade is not currently supported by all the ADP-GS because different upgrade paths.

```
  helm upgrade eric-adp-5g-udm proj-5gc-udm-helm/eric-adp-5g-udm --version "0.0.Y" --set tags.eric-adp-common=true
```

## 8. Check the status of the release

```
helm ls --all eric-adp-5g-udm
```

## 9. Delete the release

```
helm del --purge eric-adp-5g-udm
kubectl delete pvc -l release=eric-adp-5g-udm
kubectl delete pvc -l app=eric-data-search-engine
```

## 10. Build the solution ADP-GS Helm Package for release with Jenkins Job

First, push changes to git repository:

```
git add <file>...
git commit -m "commit message"
git push origin HEAD:refs/for/master
```
Then, open the URL showen in the push command and submit changes.

Open the Jenkins job: https://fem101-eiffel012.lmera.ericsson.se:8443/jenkins/view/Integration/job/helm_generate_ADP_for_UDM_solution

Build with Parameters (Example):

```
CHART_NAME=eric-cm-yang-provider
CHART_VERSION=1.4.0+14
CHART_REPO=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-all-helm
```

Once the Job has done, It can be viewed the build information (Example):

```
CHART_NAME=eric-adp-5g-udm
CHART_VERSION=0.0.570+20190116112032
CHART_REPO=https://arm.lmera.ericsson.se/artifactory/proj-5g-udm-staging-helm
TRIGGERING_CHART_NAME=eric-cm-yang-provider
TRIGGERING_CHART_VERSION=1.5.0-84
TRIGGERING_CHART_REPO=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-all-helm/
LIST_CHART_NAME=eric-cm-yang-provider,eric-adp-5g-udm
LIST_CHART_VERSION=1.5.0-84,0.0.570+20190116112032
LIST_CHART_REPO=https://arm.rnd.ki.sw.ericsson.se/artifactory/proj-adp-gs-all-helm/,https://arm.lmera.ericsson.se/artifactory/proj-5g-udm-staging-helm
```

By default the Jenkins job pushes the new ADp-GS in staging repository, once the solution Helm Package is validated and tested it can be pushed to release repository:

- Download from staging:
```
wget https://arm.lmera.ericsson.se/artifactory/proj-5g-udm-staging-helm/eric-adp-5g-udm-0.0.570+20190116112032.tgz

```

- Put it in realease:
```
curl -u $USER -X PUT https://arm.lmera.ericsson.se/artifactory/proj-5g-udm-release-helm/ -T eric-adp-5g-udm-0.0.570+20190116112032.tgz
```

- Update the semantic version of the official package by the promotion job

Open the jenkins job: https://fem101-eiffel012.lmera.ericsson.se:8443/jenkins/job/UDMstaging_promoteRelease
```
CHART_NAME=eric-adp-5g-udm
CHART_VERSION=0.0.997-20190605091519+5da3aa0
CHART_REPO=https://arm.lmera.ericsson.se/artifactory/proj-5g-udm-release-helm/
RELEASE_VERSION=0.22.0 # It is in format 0.dropNumber.x
PRODUCT_REVISION=R23A 
```
Notice that current mapping between semantic and product revison is:
0.22.0 -> R23A
0.22.0 -> R23B....
0.23.0 -> R24A...

- Apply git tag to freeze the code base
```
git tag 0.21.0
git push origin 0.21.0
```

## 11. Rebuild an EP for old drops
- Check the git tag for the drop and check out the corresponding commit
```
git checkout ebcd3ca1
```

- Then create an EP branch based on the checkout version
```
git checkout -b Demo21
```
- Update anything that needed for the rebuild then commit and push, merge in GIT

- Trigger CI job to generate EP package
 