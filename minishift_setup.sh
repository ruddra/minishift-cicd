echo "Installing necessary Packages"
docker pull openshiftdemos/nexus:2.13.0-01
docker pull openshiftdemos/gogs:latest
docker pull openshiftdemos/sonarqube:6.5
docker pull openshift/jenkins-2-centos7
docker pull openshift/jenkins-slave-maven-centos7
docker pull registry.access.redhat.com/jboss-eap-7/eap70-openshift
docker pull python

echo "logining in as developer"
oc login --server=192.168.99.100:8443 --username=developer --password=123

echo "Setting up Projects"

oc new-project dev --display-name="Tasks - Dev"
oc new-project stage --display-name="Tasks - Stage"
oc new-project cicd --display-name="CI/CD"

echo "Grant Jenkins Access to Projects"
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n dev
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n stage

echo "Use CICD"

oc project cicd

echo "Initialting services"
oc new-app -f cicd-template.yaml

echo "--- Process Completed ---"