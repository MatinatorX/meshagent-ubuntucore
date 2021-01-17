#!/usr/bin/env bash

function download() {
  read proto server path <<<$(echo ${1//// })
  DOC=/${path// //}
  HOST=${server//:*}
  PORT=${server//*:}
  [[ x"${HOST}" == x"${PORT}" ]] && PORT=80

  exec 3<>/dev/tcp/${HOST}/$PORT
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
  (while read line; do
   [[ "$line" == $'\r' ]] && break
  done && cat) <&3
  exec 3>&-
}

# Add "StartupType=(type)" to .msh file
UpdateMshFile() {
  # Remove all lines that start with "StartupType="
  sed '/^StartupType=/ d' < $SNAP_DATA/meshagent.msh >> $SNAP_DATA/meshagent2.msh
  # Add the startup type to the file
  echo "StartupType=1" >> $SNAP_DATA/meshagent2.msh
  mv $SNAP_DATA/meshagent2.msh $SNAP_DATA/meshagent.msh
}

CheckInstallAgent() {
  # echo "Checking mesh identifier..."
    url=$1
    meshid=$2
    meshidlen=${#meshid}
    if [ $meshidlen -gt 63 ]
    then
      machineid=0
      machinetype=$( uname -m )
      # If we have 3 arguments...
      if [ $# -ge 3 ]
      then
        # echo "Computer type is specified..."
        machineid=$3
      else
        # echo "Detecting computer type..."
        if [ $machinetype == 'x86_64' ] || [ $machinetype == 'amd64' ]
        then
			# Linux x86, 64 bit
			bitlen=$( getconf LONG_BIT )
			if [ $bitlen == '32' ] 
			then
				# 32 bit OS
				machineid=5
			else
				# 64 bit OS
				machineid=6
			fi
        fi
        if [ $machinetype == 'x86' ] || [ $machinetype == 'i686' ] || [ $machinetype == 'i586' ]
        then
				# Linux x86, 32 bit
				machineid=5
        fi
        if [ $machinetype == 'armv6l' ] || [ $machinetype == 'armv7l' ]
        then
          # RaspberryPi 1 (armv6l) or RaspberryPi 2/3 (armv7l)
          machineid=25
        fi
        if [ $machinetype == 'aarch64' ]
        then
          # RaspberryPi 3B+ running Ubuntu 64 (aarch64)
          machineid=26
        fi
        # Add more machine types, detect KVM support... here.
      fi
      if [ $machineid -eq 0 ]
      then
        echo "Unsupported machine type: $machinetype."
      else
        DownloadAgent $url $meshid $machineid
      fi
    else
      echo "MeshID is not correct, must be at least 64 characters long."
    fi
}

DownloadAgent() {
  url=$1
  meshid=$2
  machineid=$3
  echo "Downloading mesh agent #$machineid..."
  download $url/meshagents?id=$machineid > $SNAP_DATA/meshagent
  # If it did not work, try again using http
  if [ $? != 0 ]
  then
    url=${url/"https://"/"http://"}
    download $url/meshagents?id=$machineid > $SNAP_DATA/meshagent
  fi
  if [ $? -eq 0 ]
  then
    echo "Mesh agent downloaded."
    # TODO: We could check the meshagent sha256 hash, but best to authenticate the server.
    chmod 755 $SNAP_DATA/meshagent
    download $url/meshsettings?id=$meshid > $SNAP_DATA/meshagent.msh
    if [ $? -eq 0 ]
    then
      UpdateMshFile
    else
      echo "Unable to download mesh agent settings at: $url/meshsettings?id=$meshid."
    fi
  else
    echo "Unable to download mesh agent at: $url/meshagents?id=$machineid."
  fi
}

if [ ! $# -ge 2 ]
then
    echo -e "This script will download and configure a mesh agent. Once properly configured, it will be started as a service.\nUsage: meshagent serverurl 'meshid'"
else
    CheckInstallAgent $1 $2 $3
fi