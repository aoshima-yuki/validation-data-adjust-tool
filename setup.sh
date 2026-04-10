#!/bin/bash

set -e

if [ ! -f nifi-2.0.0-bin.zip ]; then
  echo "ERROR: nifi-2.0.0-bin.zip not found"
  echo "Please upload it manually to the repository root in Codespaces."
  exit 1
fi

echo "=== Unzip NiFi ==="
unzip -q nifi-2.0.0-bin.zip

echo "=== Clone data-adjust-tool ==="
git clone https://github.com/ODS-IS-IMDX/data-adjust-tool.git

echo "=== Copy processors ==="
cp -r data-adjust-tool/api nifi-2.0.0/python/
cp -r data-adjust-tool/extensions nifi-2.0.0/python/

echo "=== Set Python ==="
echo "nifi.python.command=python3" >> nifi-2.0.0/conf/nifi.properties
echo "nifi.python.extensions.directory=./python/extensions" >> nifi-2.0.0/conf/nifi.properties
echo "nifi.python.framework.directory=./python/framework" >> nifi-2.0.0/conf/nifi.properties

echo "=== Set NiFi login user ==="
cd nifi-2.0.0/bin
./nifi.sh stop || true
./nifi.sh set-single-user-credentials admin Password123!

echo "=== Start NiFi ==="
./nifi.sh start

echo "=== Done ==="
echo "Open PORT 8443 in Codespaces"
echo "Login with: admin / Password123!"