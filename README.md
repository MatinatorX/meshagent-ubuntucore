# MeshCentral Agent for Ubuntu Core

Adds a MeshCentral agent for remote access to Ubuntu Core devices. Requires devmode and beta options due to the permissions required by the meshagent binary. As such, YOU INSTALL THIS AT YOUR OWN RISK.

To install:
`sudo snap install meshagent --beta --devmode`

MeshCentral is developed by the supremely talented Ylian Saint-Hilaire. This snap was developed independently to allow meshagents to run on Ubuntu Core devices such as the Dell Edge gateways 3001.

To configure, call meshagent while passing the URL and the MeshID. These can be found in the Linux/BSD section of the "Add Agent" option on your MeshCentral website. For example:

`meshagent https://meshcentral.com 'fDPvApR25JcO0rNaOQu7YzWBuYwu5ydmvKjWCT@U9e27IZrD7EE9tAMUObzBwORK'`
