#!/bin/bash
#
# --- Input ---
#
simplepush_id='123abc'
#
# melde den Plattenplatz aufs Handy
echo '--- Melde Plattenplatz aufs Handy ---'
msg1=$(df -h | awk '{if (match($1,/(Intenso)/)) {print "Kodi " $4}}')
msg2=$(df -h | awk '{if (match($1,/(sda1)/)) {print "HDD6T " $4}}')
msg3=$(df -h | awk '{if (match($1,/(sdb1)/)) {print "SSD-Sys " $4}}')
msg4=$(df -h | awk '{if (match($1,/(sdb2)/)) {print "SSD-Dat " $4}}')
msg=$(echo "$msg1 - $msg2 - $msg3 - $msg4") && curl "https://api.simplepush.io/send/${simplepush_id}/fertig/$msg" 
#
echo '--- Fertig ---'
date
