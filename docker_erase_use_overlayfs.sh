#! /usr/bin/env bash

function continueOrQuit {
  read -r -p "${1} Continue? [y/N] " response
    response=${response,,}    # tolower
    case $response in
      [y][e][s]|[y]) 
        echo "...continuing with operation"
        ;;
      *)
        echo "...aborting operation"
        exit 1
        ;;
    esac	       
}  

## VERIFY OPERATION
echo "<<< MAKE SURE YOU RUN WITH ELEVATED PERMISSIONS >>>"
echo "!!!THIS WILL ERASE ALL YOUR DOCKER IMAGES TO SWITCH TO OVERLAYFS!!!"
continueOrQuit ''

## STOP DOCKER

systemctl stop docker
if [ $? -ne 0 ]
 then
  continueOrQuit 'Unable to stop docker (may be already stopped).'
fi

## REMOVE EXISTING /var/lib/docker

rm -r /var/lib/docker
if [ $? -ne 0 ]
 then
  continueOrQuit 'Unable to remove existing docker images (may be already removed).'
fi

## ADD OVERLAYFS
# adapted from https://gist.github.com/cpswan/4dd60dd3b000a514f6bf
# THIS ASSUMES DOCKER 1.12+
# See comment inline for prior versions
mkdir -p /etc/systemd/system/docker.service.d
if [ $? -ne 0 ]
 then
  continueOrQuit 'Unable to make `docker.service.d` directory.'
fi


bash -c 'cat <<EOF > /etc/systemd/system/docker.service.d/overlay.conf
[Service]
ExecStart=
## Uncomment the following for docker version < 1.12:
# ExecStart=/usr/bin/docker daemon -H fd:// --storage-driver=overlay
## Comment the following for docker version < 1.12:
ExecStart=/usr/bin/docker daemon --storage-driver=overlay
EOF'
if [ $? -ne 0 ]
 then
  continueOrQuit 'Unable to create `overlay.conf` in `/etc/systemd/system/docker.service.d` .'
fi

## UPDATE SYSTEMCTL AND RESTART DOCKER
systemctl daemon-reload
systemctl start docker
systemctl status docker





