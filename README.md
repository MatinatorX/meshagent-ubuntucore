# MeshCentral Agent for Ubuntu Core

Adds a MeshCentral agent for remote access to Ubuntu Core devices. Requires devmode and beta options due to the permissions required by the meshagent binary. As such, YOU INSTALL THIS AT YOUR OWN RISK.

MeshCentral is developed by the very talented Ylian Saint-Hilaire. This unofficial snap was created to allow MeshCentral agents to run on Ubuntu Core devices such as the Dell Edge Gateway 3001. Please visit the MeshCentral website for more information:

https://meshcentral.com/info/

To install:

```
sudo snap install meshagent-ubuntucore --beta --devmode
```

To configure, call the snap while passing the URL and the MeshID as arguments. These can be found in the Linux/BSD section of the "Add Agent" option on your MeshCentral website. For example:

```
meshagent-ubuntucore https://meshcentral.com 'fDPvApR25JcO0rNaOQu7YzWBuYwu5ydmvKjWCT@U9e27IZrD7EE9tAMUObzBwORK'
```

## Building the Snap

If building on an Ubuntu Core device, you will have to install the classic snap first, then enter the classic snap shell.

```
sudo snap install classic --beta --devmode
classic
```

Then, install snapcraft:

```
sudo snap install snapcraft
```

If using an older version of Ubuntu Core, you may have to install with apt:

```
apt install snapcraft
```

Copy the source somewhere, such as your home directory.

Run `snapcraft` in source directory to build. The snap file will output to the same directory.
