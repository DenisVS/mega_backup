#!/bin/sh
# Only nested directories in configured paths will be copied correctly!
# MEGA_BACKUP_PATHS file
# c:/Users/master/Downloads/test dir|1    copy only missing directories
# #c:/Shares|0                            commented line, skip
# c:/Users/master/Documents/Projects|0    copy every directories into new DATE-TIME directory

MEGATOOLS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/megatools.exe'
MEGA_CREDENTIALS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega.ini'
MEGA_BACKUP_PATHS='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega_server_backup_paths.ini'
MEGA_CLOUD_PATH="/Root/Backups/ServerModularWin"  # Root for all backups

DATE=$(date "+%Y%m%d_%H%M")
USERNAME=$(cat "$MEGA_CREDENTIALS_PATH" | grep Username | awk -F \= '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
PASSWORD=$(cat "$MEGA_CREDENTIALS_PATH" | grep Password | awk -F \= '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
echo  u "$USERNAME"   p "$PASSWORD" 
### analog of mkdir -p
PATH_BEFORE_ACTUAL_DIR=""
$MEGATOOLS_PATH test -u "$USERNAME" -p "$PASSWORD" -d  --reload "/Root"        ## Refresh cache
PATH_ARRAY=$(echo $MEGA_CLOUD_PATH | tr "/" " ") #MEGA path splitted
for CURRENT_LAST_DIR_IN_CYCLE in ${PATH_ARRAY}; do
  PATH_BEFORE_ACTUAL_DIR="$PATH_BEFORE_ACTUAL_DIR/$CURRENT_LAST_DIR_IN_CYCLE"
  $MEGATOOLS_PATH test  -u "$USERNAME" -p "$PASSWORD" -d "${PATH_BEFORE_ACTUAL_DIR}"
  TEST="$?"
  echo test $TEST
  if [ "$TEST" = 0 -o $PATH_BEFORE_ACTUAL_DIR = '/Root' ]; then
    echo Dir exists
  else
    echo Let\'s make $PATH_BEFORE_ACTUAL_DIR
    $MEGATOOLS_PATH mkdir  -u "$USERNAME" -p "$PASSWORD" "$PATH_BEFORE_ACTUAL_DIR"
  fi

done
#echo 2 "$PATH_BEFORE_ACTUAL_DIR"
PATH_BEFORE_ACTUAL_DIR=$MEGA_CLOUD_PATH
$MEGATOOLS_PATH mkdir  -u "$USERNAME" -p "$PASSWORD" "$PATH_BEFORE_ACTUAL_DIR/$DATE"

# Arrays of paths
PATHS_0=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($2==0)  print $1}')
PATHS_1=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($2==1)  print $1}')
echo 0 $PATHS_0
echo 1 $PATHS_1 # Path for copy non dated dirs
#exit

#################################################
## New block of direct copy dirs which don't exist
SAVEIFS=${IFS}
IFS='
'
for CURRENT_PATH in ${PATHS_1}; do
  echo Current Path \(Subroot where our non dated dirs contain\) $CURRENT_PATH
  LAST_DIR=$(echo $CURRENT_PATH | awk -F "/" '{print $NF}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo Last dir: $LAST_DIR # To create subroot for non dated dirs
  echo Mega cloud path \(Root for our backups\): $MEGA_CLOUD_PATH

  #test and create dir for not by date backups
echo Test new subroot before create "${MEGA_CLOUD_PATH}/${LAST_DIR}"
  $MEGATOOLS_PATH test  -u "$USERNAME" -p "$PASSWORD" -d "${MEGA_CLOUD_PATH}/${LAST_DIR}"
  TEST="$?"
  echo test $TEST
  if [ "$TEST" = 0 -o $PATH_BEFORE_ACTUAL_DIR = '/Root' ]; then
    echo Dir exists
  else
    echo Let\'s make "${MEGA_CLOUD_PATH}/${LAST_DIR}"
    $MEGATOOLS_PATH mkdir  -u "$USERNAME" -p "$PASSWORD" "${MEGA_CLOUD_PATH}/${LAST_DIR}" # Create subroot dir for non dated dirs
  fi

  LOCAL_DIRS_TO_BACKUP=$(find $CURRENT_PATH -maxdepth 1 -mindepth 1 -type d | awk -F \/ '{print $NF}')
  ### Cycle all dirs in folders
  for CURRENT_DIR_TO_BACKUP in ${LOCAL_DIRS_TO_BACKUP}; do
  echo Testing CURRENT_DIR_TO_BACKUP dir under subroot before create "$CURRENT_DIR_TO_BACKUP"
    $MEGATOOLS_PATH test  -u "$USERNAME" -p "$PASSWORD" -d "${MEGA_CLOUD_PATH}/${LAST_DIR}/${CURRENT_DIR_TO_BACKUP}"
    TEST="$?"
    echo test $TEST
    if [ "$TEST" = 0 ]; then
      echo Dir exists
    else
      echo Let\'s copy  "${CURRENT_PATH}/${CURRENT_DIR_TO_BACKUP}" to "${MEGA_CLOUD_PATH}/${LAST_DIR}/${CURRENT_DIR_TO_BACKUP}"
      echo $MEGATOOLS_PATH copy  -u "$USERNAME" -p "$PASSWORD" --local  "${CURRENT_PATH}/${CURRENT_DIR_TO_BACKUP}" --remote "${MEGA_CLOUD_PATH}/${LAST_DIR}/${CURRENT_DIR_TO_BACKUP}"
      $MEGATOOLS_PATH mkdir  -u "$USERNAME" -p "$PASSWORD" "${MEGA_CLOUD_PATH}/${LAST_DIR}/${CURRENT_DIR_TO_BACKUP}" # Create CURRENT_DIR_TO_BACKUP (curent non dated dir)

      $MEGATOOLS_PATH copy  -u "$USERNAME" -p "$PASSWORD" --local "${CURRENT_PATH}/${CURRENT_DIR_TO_BACKUP}" --remote "${MEGA_CLOUD_PATH}/${LAST_DIR}/${CURRENT_DIR_TO_BACKUP}"
      #exit ###########################################################################

    fi

  done
done
#exit

#################################################
# Create dirs and copy there content by date.
for CURRENT_PATH in ${PATHS_0}; do
  echo $CURRENT_PATH
  LAST_DIR=$(echo $CURRENT_PATH | awk -F "/" '{print $NF}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  $MEGATOOLS_PATH mkdir -u "$USERNAME" -p "$PASSWORD"  "$PATH_BEFORE_ACTUAL_DIR/$DATE/$LAST_DIR"
  CURRENT_PATH=$(echo $CURRENT_PATH | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo Current Path "$CURRENT_PATH"
  $MEGATOOLS_PATH copy  -u "$USERNAME" -p "$PASSWORD" --local "${CURRENT_PATH}" --remote "$PATH_BEFORE_ACTUAL_DIR/$DATE/$LAST_DIR"
done

#################################################

IFS=${SAVEIFS}

SAVEIFS=${IFS}
IFS='
'
#exit
