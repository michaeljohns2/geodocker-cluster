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
echo "!!!THIS WILL ERASE ALL YOUR DOCKER IMAGES TO SWITCH BACK TO DEFAULT STORAGE DRIVE (E.G. DEVICEMAPPER ON CENTOS 7) !!!"
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

## REMOVE EXISTING overlay.conf

rm /etc/systemd/system/docker.service.d/overlay.conf
if [ $? -ne 0 ]
 then
  continueOrQuit 'Unable to remove `overlay.conf` in `/etc/systemd/system/docker.service.d` .'
fi

## UPDATE SYSTEMCTL AND RESTART DOCKER
systemctl daemon-reload
systemctl start docker
systemctl status docker





