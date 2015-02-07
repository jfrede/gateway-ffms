#!/bin/bash

# Implementierung einer Fastd Blacklist 
# Das Script wird aus Fastd beim Aufbau einer Verbidung aufgerufen
# Die geblockten Keys werden in der Datei blacklist aufgeführt

PEER_KEY=$1

if /bin/grep -Fq $PEER_KEY /var/gateway-ffms/fastd/blacklist; then
	exit 1
else
	exit 0
fi
