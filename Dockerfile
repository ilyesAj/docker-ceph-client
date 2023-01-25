# ceph-fuse is only available for amd64 arch
FROM amd64/ubuntu:20.04


ENV MONITOR_HOSTS ''
ENV CEPH_USER ''
ENV CEPH_CLUSTER_NAME ''
ENV CEPH_KEYRING_BASE64 ''
ENV CEPH_VOLUME_PATH '/'
ENV CEPH_MOUNT '/data'
RUN apt-get update && \
    apt-get install -y ceph-common ceph-fuse tini gettext-base\
    && rm -rf /var/lib/apt/lists/*

RUN mkdir $CEPH_MOUNT

COPY ceph.conf.template /templates/ceph.conf.template

COPY *.sh /usr/local/bin/


HEALTHCHECK \
  --interval=15s \
  --timeout=5s \
  --start-period=15s \
  --retries=2 \
  CMD [ "/usr/local/bin/healthcheck.sh" ]

# The default is to perform all system-level mounting as part of the entrypoint
# to then have a command that will keep listing the files under the main share.
# Listing the files will keep the share active and avoid that the remote server
# closes the connection.
ENTRYPOINT [ "tini", "-g", "--", "docker-entrypoint.sh" ]
CMD [ "empty.sh" ]