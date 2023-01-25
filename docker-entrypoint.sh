#!/bin/bash
set -e

if [ "$MONITOR_HOSTS" == "" ]; then
    echo "MONITOR_HOSTS is mandatory"
    exit 1
fi
if [ "$CEPH_KEYRING_BASE64" == "" ]; then
    echo "CEPH_KEYRING_BASE64 is mandatory"
    exit 1
fi
if [ "$CEPH_USER" == "" ]; then
    echo "CEPH_KEYRING_BASE64 is mandatory"
    exit 1
fi
if [ "$CEPH_CLUSTER_NAME" == "" ]; then
    echo "CEPH_CLUSTER_NAME is mandatory"
    exit 1
fi
if [ "$CEPH_VOLUME_PATH" == "/" ]; then
    echo "VOLUME_PATH is set to default ; mounting on ceph root path"
    exit 1
fi

_error() {
  printf %s\\n "$1" >&2
  exit 1
}

# create ceph config file
echo "Creating ceph.client.${CEPH_USER}.keyring ..."
cat /templates/ceph.conf.template | envsubst > /ceph.client.${CEPH_USER}.keyring 
cat ceph.client.${CEPH_USER}.keyring 
#chmod 600 ceph.client.${CEPH_USER}.keyring 

mkdir -p /etc/ceph/
touch /etc/ceph/ceph.conf
echo "Initialization done."
echo ""
# mounting the volume
echo "Mounting volume ${CEPH_VOLUME_PATH} onto ${CEPH_MOUNT}"
echo "EXECUTING: ceph-fuse --keyring /ceph.client.${CEPH_USER}.keyring --name client.${CEPH_USER} --no-mon-config -m ${MONITOR_HOSTS} -r ${CEPH_VOLUME_PATH} ${CEPH_MOUNT}"
ceph-fuse --keyring /ceph.client.${CEPH_USER}.keyring --name client.${CEPH_USER} --no-mon-config -m ${MONITOR_HOSTS} -r ${CEPH_VOLUME_PATH} ${CEPH_MOUNT}

# check if mount is succefull 
if healthcheck.sh; then
    echo "Mounted bucket ${CEPH_VOLUME_PATH} onto ${CEPH_MOUNT}"
    # exec empty.sh
    exec "$@"
else
    _error "Mount failure"
fi
         