#!/bin/sh

# Mesh Agent Service Script

if [ -f "$SNAP_DATA/meshagent" ]; then
    $SNAP_DATA/meshagent
	echo "Mesh agent started."
else
	echo "Could not start mesh agent: $SNAP_DATA/meshagent not found."
	exit 1
fi