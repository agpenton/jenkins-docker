FROM jenkins/jenkins:lts
LABEL mantainer="Asdrubal Gonzalez" description="Jenkins with Docker to build docker images and pull on the registry and ansible to provision"
ENV DEBIAN_FRONTEND noninteractive
ENV pip_packages "ansible cryptography yamllint ansible-lint flake8 testinfra molecule"
USER root

RUN apt update && apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
apt-get update && apt-get -y install docker-ce && usermod -aG docker jenkins && apt-get update \
    && apt-get install -y --no-install-recommends \
       sudo systemd \
       build-essential libffi-dev libssl-dev \
       python-pip python-dev python-setuptools python-wheel \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean && apt autoclean -y \
&& rm -Rf /var/cache/apt/archives/* /var/cache/apt/pkgcache.bin /var/cache/apt/srcpkgcache.bin && apt clean -y \
&& pip install $pip_packages
COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl && mkdir -p /etc/ansible && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]

USER jenkins
