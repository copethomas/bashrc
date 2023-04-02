#!/bin/bash
#Cleans downloads older then one week
#-Thomas Cope
find /home/tom/Downloads/ -type f -mtime +7 -delete
