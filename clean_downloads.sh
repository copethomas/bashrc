#!/bin/bash
#Cleans downloads older then one week
#-Thomas Cope
#
# Crontab line:
# 0 21 * * * /home/tom/bin/clean_downloads.sh
#
find /home/tom/Downloads/ -type f -mtime +7 -delete
