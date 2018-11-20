#!/bin/sh

# fail fast
set -e -u

# Configure the timezone
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo $TZ > /etc/timezone
MOUNT_PATH=/unionfs

echo "$( date +'%Y/%m/%d %H:%M:%S' ) Mounting /read-only + /read-write as /unionfs"

function term_handler {
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Sending SIGTERM to child pid"
  kill -SIGTERM ${!}      #kill last spawned background process $(pidof unionfs)
  fuse_unmount
  echo "exiting container now"
  exit $?
}

function cache_handler {
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Sending SIGHUP to child pid"
  kill -SIGHUP ${!}
}

function fuse_unmount {
  echo "$( date +'%Y/%m/%d %H:%M:%S' ) Unmounting $MOUNT_PATH"
  fusermount -uz $MOUNT_PATH
}

# Add traps, SIGHUP is for cache clearing
trap term_handler SIGINT SIGTERM
trap cache_handler SIGHUP

/usr/bin/unionfs \
  -o allow_other `# allow access to other users` \
  -o auto_cache `# enable caching based on modification times` \
  -o auto_unmount `# auto unmount on process termination` \
  -o cow `# enable copy-on-write` \
  -o direct_io `# use direct I/O` \
  -o gid=$PGID `# set file group` \
  -o sync_read `# perform reads synchronously` \
  -o uid=$PUID `# set file owner` \
  -f `# foreground operation` \
  /read-write=RW:/read-only=RO \
  /unionfs

echo "$( date +'%Y/%m/%d %H:%M:%S' ) unionfs crashed ($?)"
fuse_unmount

exit $?
