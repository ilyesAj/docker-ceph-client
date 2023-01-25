#!/bin/sh

set -eu

# Where are we going to mount the remote volume resource in our container.
CEPH_MOUNT=${CEPH_MOUNT:-/data}

# Test if there is still a ceph-fuse mount onto the destination mountpoint. We
# use /proc/mounts because it contains fresh information, always.
grep ceph-fuse /proc/mounts | grep -q "${CEPH_MOUNT}" || exit 1