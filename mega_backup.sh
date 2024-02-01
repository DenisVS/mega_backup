#!/bin/sh
# Only nested downstream  directories in configured paths will be copied correctly!
# MEGA_BACKUP_PATHS file
# c:/Users/master/Downloads/test dir|/Root/Backup38/AA|1    copy only missing directories
# #c:/Shares|/Root/Backup38|0                            commented line, skip
# c:/Users/master/Documents/Projects|/Root/Backup2|0    copy every directories into new DATE-TIME directory
#PATH=$(echo /usr/local/bin:/usr/bin)

#. ./config.sh
#. ./functions.sh
source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/functions.sh"






SAVEIFS=${IFS}
IFS='
'
for CURRENT_ELEMENT in ${BACKUP_OBJECT_2}; do
  IFS=${SAVEIFS}
  ELEMENT_LOCAL_PATH=$(echo $CURRENT_ELEMENT | awk -F "|" '{print $1}')
  ELEMENT_CLOUD_PATH=$(echo $CURRENT_ELEMENT | awk -F "|" '{print $2}')
  echo ELEMENT_LOCAL_PATH $ELEMENT_LOCAL_PATH
  echo ELEMENT_CLOUD_PATH $ELEMENT_CLOUD_PATH

  #FILENAME=`echo ${CURRENT_ARCHIVE} | awk -F '/' '{i = 1; for (--i; i >= 0; i--){ printf "%s\t",$(NF-i)} print ""}'`
  #echo $FILENAME
  _mega_mkdir_p "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH"

  #local files
  RESULT=$(find "$ELEMENT_LOCAL_PATH" -maxdepth 1 -mindepth 1 -type f | awk -F \/ '{print $NF}')

  SAVEIFS=${IFS}
  IFS='
'
  for FILE_NAME in ${RESULT}; do
    IFS=${SAVEIFS}
    echo $FILE_NAME ss
    echo sent "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH--"$FILE_NAME"---> function copy"
    _mega_copyfile_if_not_exist "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH" "$FILE_NAME" "1"
  done

  exit

  echo -------------------------
done
exit

###########################

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
  echo sent "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH--"$DATE"---> function copy"
  _mega_copy_if_not_exist "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "$ELEMENT_CLOUD_PATH" "$ELEMENT_LOCAL_PATH" "$DATE"

  echo -------------------------
done
