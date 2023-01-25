#!/bin/sh

exit_script() {
    SIGNAL=$1
    echo "Caught $SIGNAL! Unmounting ${CEPH_MOUNT}..."
    fusermount -u "${CEPH_MOUNT}"
    trap - "$SIGNAL" # clear the trap
    exit $?
}

trap "exit_script INT" INT
trap "exit_script TERM" TERM