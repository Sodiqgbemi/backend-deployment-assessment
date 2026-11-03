#!/bin/bash
set -euxo pipefail

cat > /etc/yum.repos.d/mongodb-org-7.0.repo <<'EOF'
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

# Retry installation in case the package repository is temporarily unavailable
for attempt in 1 2 3 4 5; do
    if yum install -y mongodb-org; then
        break
    fi

    if [ "$attempt" -eq 5 ]; then
        echo "MongoDB installation failed after 5 attempts"
        exit 1
    fi

    sleep 15
done

# Allow connections on the private network interface
sed -i -E 's/^[[:space:]]*bindIp:.*/  bindIp: 0.0.0.0/' /etc/mongod.conf

systemctl enable --now mongod