#! /usr/bin/env sh

CEPH_MOUNT=${CEPH_MOUNT:-/data}
# shellcheck disable=SC1091
. trap.sh

tail -f /dev/null