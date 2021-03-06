#!/bin/bash

### CONFIGURATION ###

# Set the paths, as cron will not do this
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Set the number of the iptables mark, to catch the packets and route them through the tunnel
iptables_mark=1

# Set the destination ips to use for pinging
destination_ips=( '78.46.108.155' '78.46.108.150' '46.38.251.123' '8.8.8.8' )

# Set the source interface
source_if='tun0'

# Logfile path
log_path='/var/log/watchdog_mullvad.log'

### FUNCTIONS ###

function execute_on_fail() {
	batctl gw off
}

function execute_on_recover() {
        batctl gw server
}

function separator() {
	echo "" >> $log_path
}

function log() {
	date "+%Y/%m/%d %H:%M:%S: $1" >> $log_path
}

### CODE ###

separator

for destination_ip in ${destination_ips[@]}; do
    log "Trying to get a reply from $destination_ip..."
	ping -q -I $source_if -c1 -m $iptables_mark $destination_ip >& /dev/null
	if [ $? -eq 0 ]; then
		log "Got a reply from $destination_ip, so everything seems to be in order. Running 'execute_on_recover'..."
		execute_on_recover
		exit 0
	fi
	sleep 1
done

log "Did not get a reply from any destination ip, so there seems to be a problem. Running 'execute_on_fail'..."
execute_on_fail
exit 1
