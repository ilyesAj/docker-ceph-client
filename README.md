# docker-ceph-client
docker container that mounts a Ceph volume


This docker image contains all ceph libraries that will help you mount a ceph volume .

You need to add extra sys-capabilities to use fuse. You can always run it with --privileged. However this should be avoided, to run with a more restricted set use:
```
--cap-add mknod --cap-add sys_admin --device=/dev/fuse
```

> this project is particularly useful for mac and arm architecture users since ceph does not provide packages for those distributions
## pre-requesties

### Linux users 
make sure that fuse is loaded before running the container . 
```
modprobe fuse
```
### Mac M1 users 
First you need to install fuse ; and this is challanging: 
1. Uninstall macFUSE
2. Disable System Integrity Protection https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection
3. While System Integrity Protection is disabled, install macFUSE (`brew install macfuse`)
4. Do a restart without enabling System Integrity Protection and load/approve the macFUSE Extension in the Security Pane
Enable System Integrity Protection

Make sure that macfuse is loaded : 
```
sudo kextload /Library/Filesystems/macfuse.fs/Contents/Extensions/11/macfuse.kext
```
[source](https://github.com/osxfuse/osxfuse/issues/828)
After this you can run your container .

- For `rshared` option on the volume, you may have some issues with docker for mac .
- You need to export `export DOCKER_DEFAULT_PLATFORM=linux/amd64` in order to run the container for m1 mac . `ceph-fuse` is only available on `amd64` architecture. 

## Run 

docker-compose is available to run .
```
docker-compose up
```
## Docker options

- `MONITOR_HOSTS`: ceph monitors
- `CEPH_USER`: ceph user/client
- `CEPH_CLUSTER_NAME`: name of ceph cluster, default is `ceph`
- `CEPH_KEYRING_BASE64`: ceph keyring to authentificate
- `CEPH_VOLUME_PATH`: ceph volume to mount
- `CEPH_MOUNT`: Local folder on container to be mounted, default is `/data`

## references
- https://github.com/flaviostutz/ceph-client
- https://github.com/gvangool/docker-ceph-fuse
- https://docs.ceph.com/en/quincy/cephfs/mount-using-fuse/
- https://subscription.packtpub.com/book/application-development/9781784393502/4/ch04lvl1sec48/accessing-cephfs-via-fuse-client
- https://qnib.org/blog/2015/12/14/simple-ceph-container-with-ceph-fuse-clients/index.html
- https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/2/html/ceph_file_system_guide_technology_preview/mounting_and_unmounting_ceph_file_systems#unmounting_ceph_file_systems
- https://github.com/osxfuse/osxfuse/issues/851