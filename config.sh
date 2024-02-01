#!/bin/sh
# Only nested directories in configured paths will be copied correctly!
# MEGA_BACKUP_PATHS file
# c:/Users/master/Downloads/test dir|1    copy only missing directories
# #c:/Shares|0                            commented line, skip
# c:/Users/master/Documents/Projects|0    copy every directories into new DATE-TIME directory
PATH=`echo /usr/local/bin:/usr/bin`


MEGATOOLS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/megatools.exe'
MEGA_CREDENTIALS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega.ini'
MEGA_BACKUP_PATHS='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega_server_backup_paths.ini'
ELEMENT_CLOUD_PATH="/Root/Backups/Server/ModularWin3" # Root for all backups


DATE=$(date "+%Y%m%d_%H%M")
USERNAME=$(cat "$MEGA_CREDENTIALS_PATH" | grep Username | awk -F \= '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
PASSWORD=$(cat "$MEGA_CREDENTIALS_PATH" | grep Password | awk -F \= '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
echo u "$USERNAME" p "$PASSWORD"

# Arrays of elements for backup from config file
BACKUP_OBJECT_0=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($3==0)  print $1 "|" $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
BACKUP_OBJECT_1=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($3==1)  print $1 "|" $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
BACKUP_OBJECT_2=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($3==2)  print $1 "|" $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

