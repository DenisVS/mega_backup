#!/bin/sh
# Only nested directories in configured paths will be copied correctly!
# MEGA_BACKUP_PATHS file
# c:/Users/master/Downloads/test dir|1    copy only missing directories
# #c:/Shares|0                            commented line, skip
# c:/Users/master/Documents/Projects|0    copy every directories into new DATE-TIME directory
. ./config.sh
. ./functions.sh

SAVEIFS=${IFS}
IFS='
'
for CURRENT_ELEMENT in ${BACKUP_OBJECT_0}; do
  IFS=${SAVEIFS}
  ELEMENT_LOCAL_PATH=$(echo $CURRENT_ELEMENT | awk -F "|" '{print $1}')
  ELEMENT_CLOUD_PATH=$(echo $CURRENT_ELEMENT | awk -F "|" '{print $2}')
  echo ELEMENT_LOCAL_PATH $ELEMENT_LOCAL_PATH
  echo ELEMENT_CLOUD_PATH $ELEMENT_CLOUD_PATH
  echo sent "$ELEMENT_CLOUD_PATH" "-----> function mkdir"
  _mega_mkdir_p "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH"
  PATH=$(echo /usr/local/bin:/usr/bin)
  find "$ELEMENT_LOCAL_PATH" -maxdepth 1 -mindepth 1 -type d | awk -F \/ '{print $NF}'
  LOCAL_DIRS_TO_BACKUP=$(find "$ELEMENT_LOCAL_PATH" -maxdepth 1 -mindepth 1 -type d | awk -F \/ '{print $NF}')
  echo LOCAL_DIRS_TO_BACKUP $LOCAL_DIRS_TO_BACKUP
  SAVEIFS=${IFS}
  IFS='
'
  for CURRENT_DIR_TO_BACKUP in ${LOCAL_DIRS_TO_BACKUP}; do
    IFS=${SAVEIFS}
    echo CURRENT_DIR_TO_BACKUP "$CURRENT_DIR_TO_BACKUP"
    echo ELEMENT_CLOUD_PATH/CURRENT_DIR_TO_BACKUP:
    echo sent "$ELEMENT_CLOUD_PATH/$CURRENT_DIR_TO_BACKUP" "$ELEMENT_LOCAL_PATH-----> function copy"
    _mega_copy_if_not_exist "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH/$CURRENT_DIR_TO_BACKUP" "$ELEMENT_LOCAL_PATH"
    PATH=$(echo /usr/local/bin:/usr/bin)
  done
  IFS=${SAVEIFS}
  echo -------------------------
done

SAVEIFS=${IFS}
IFS='
'
for CURRENT_ELEMENT in ${BACKUP_OBJECT_1}; do
  IFS=${SAVEIFS}
  ELEMENT_LOCAL_PATH=$(echo $CURRENT_ELEMENT | awk -F "|" '{print $1}')
  ELEMENT_CLOUD_PATH=$(echo $CURRENT_ELEMENT | awk -F "|" '{print $2}')
  echo ELEMENT_LOCAL_PATH $ELEMENT_LOCAL_PATH
  echo ELEMENT_CLOUD_PATH $ELEMENT_CLOUD_PATH
  _mega_mkdir_p "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH/$DATE"
  PATH=$(echo /usr/local/bin:/usr/bin)
  echo sent "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH--"$DATE"---> function copy"

  _mega_copy_if_not_exist "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH" "$DATE"
  #_mega_copy_if_not_exist "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH" "rrrrr"
  PATH=$(echo /usr/local/bin:/usr/bin)

  echo -------------------------
done
