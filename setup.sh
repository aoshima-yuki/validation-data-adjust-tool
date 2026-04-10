#!/bin/bash

set -e

echo "=== Download NiFi ==="
curl -L -O https://archive.apache.org/dist/nifi/2.0.0/nifi-2.0.0-bin.zip

echo "=== Unzip NiFi ==="
unzip -q nifi-2.0.0-bin.zip

echo "=== Clone data-adjust-tool ==="
git clone https://github.com/ODS-IS-IMDX/data-adjust-tool.git

echo "=== Copy processors ==="
cp -r data-adjust-tool/api nifi-2.0.0/python/
cp -r data-adjust-tool/extensions nifi-2.0.0/python/

echo "=== Set Python ==="
sed -i 's|^nifi.python.command=.*|nifi.python.command=python3|' nifi-2.0.0/conf/nifi.properties

echo "=== Start NiFi ==="
cd nifi-2.0.0/bin
./nifi.sh start

echo "=== Done ==="
echo "Open PORT 8443 in Codespaces"
