# docker-ceph-client
docker container that mounts a Ceph volume


This docker image contains all ceph libraries that will help you mount a ceph volume .

You need to add extra sys-capabilities to use fuse. You can always run it with --privileged. However this should be avoided, to run with a more restricted set use:
```
--cap-add mknod --cap-add sys_admin --device=/dev/fuse
```