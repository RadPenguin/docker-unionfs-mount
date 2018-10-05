# docker-unionfs-mount

Create a unionfs mount between a read only source, and a read/write source folder;

## Usage
```
docker create \
  --name=unionfs \
  --env TZ="America/Edmonton" \
  --privileged \
  --volume $( pwd )/local:/read-write:shared \
  --volume $( pwd )/remote:/read-only:shared \
  --volume $( pwd )/unionfs:/unionfs:shared \
  radpenguin/unionfs-mount
```

## Parameters
The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
```
--env TZ - the timezone to use for the cron and log. Defaults to `America/Edmonton`
--volume /read-write - The read write mount point
--volume /read-only - The read only mount point
--volume /unionfs - The unionfs mount
```

It is based on alpine linux. For shell access while the container is running, `docker exec -it unionfs-mount /bin/bash`.
