FROM dyne/devuan:daedalus

WORKDIR /root
RUN apt update && \
    apt install -y openrc policycoreutils sysvinit-core && \
    apt install -y sudo gpg openssh-server && \
    apt install -y -y apt-transport-https ca-certificates curl && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list && \
    chmod 644 /etc/apt/sources.list.d/kubernetes.list && \
    apt update && \
    apt install -y kubectl wget tmux vim make && \
    apt install -y sssd-ldap ldap-utils && \
    sed -i 's/DAEMON_OPTS="-D -f"/DAEMON_OPTS="-D"/' /etc/default/sssd && \
    rc-update add sssd && \
    rc-update add ssh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/sbin/init"]
