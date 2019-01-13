FROM jenkins/jenkins:lts
LABEL mantainer="Asdrubal Gonzalez" description="Jenkins with Docker to build docker images and pull on the registry"
USER root

RUN apt -y remove docker docker-engine docker.io containerd runc && apt update && apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
apt-get update && apt-get -y install docker-ce && usermod -aG docker jenkins && apt autoclean -y && rm -Rf /var/cache/apt/archives/* /var/cache/apt/archives/partial/* /var/lib/apt/lists/partial/* /var/cache/apt/pkgcache.bin /var/cache/apt/srcpkgcache.bin && apt clean -y

#RUN apt-get install -y docker-ce

#RUN usermod -a -G docker jenkins

USER jenkins
