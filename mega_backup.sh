#!/bin/sh
MEGATOOLS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/megatools.exe'
MEGA_CREDENTIALS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega.ini'
MEGA_BACKUP_PATHS='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega_server_backup_paths.ini'
MEGA_CLOUD_PATH="/Root/Backups/ServerModularWin"

DATE=$(date "+%Y%m%d_%H%M")
USERNAME=$(cat "$MEGA_CREDENTIALS_PATH" | grep Username | awk -F \= '{print $2}')
PASSWORD=$(cat "$MEGA_CREDENTIALS_PATH" | grep Password | awk -F \= '{print $2}')

### analog of mkdir -p
PATH_BEFORE_ACTUAL_DIR=""
$MEGATOOLS_PATH test -d  --reload "/Root" ## Refresh cache
PATH_ARRAY=$(echo $MEGA_CLOUD_PATH | tr "/" " ") #MEGA path splitted
for CURRENT_LAST_DIR_IN_CYCLE in ${PATH_ARRAY}; do
  PATH_BEFORE_ACTUAL_DIR="$PATH_BEFORE_ACTUAL_DIR/$CURRENT_LAST_DIR_IN_CYCLE"
  $MEGATOOLS_PATH test -d "${PATH_BEFORE_ACTUAL_DIR}"
  TEST="$?"
  echo test $TEST
  if [ "$TEST" = 0 -o $PATH_BEFORE_ACTUAL_DIR = '/Root' ]; then
    echo Dir exists
  else
    echo Let\'s make $PATH_BEFORE_ACTUAL_DIR
    $MEGATOOLS_PATH mkdir "$PATH_BEFORE_ACTUAL_DIR"
  fi

done
#echo 2 "$PATH_BEFORE_ACTUAL_DIR"
PATH_BEFORE_ACTUAL_DIR=$MEGA_CLOUD_PATH
$MEGATOOLS_PATH mkdir "$PATH_BEFORE_ACTUAL_DIR/$DATE"

# Arrays of paths
PATHS_0=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($2==0)  print $1}')
PATHS_1=$(cat $MEGA_BACKUP_PATHS | grep -v \# | awk -F\| '{if($2==1)  print $1}')
echo 0 $PATHS_0
echo 1 $PATHS_1
#exit

for CURRENT_PATH in ${PATHS_0}; do
  echo $CURRENT_PATH
  LAST_DIR=$(echo $CURRENT_PATH | awk -F "/" '{print $NF}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  $MEGATOOLS_PATH mkdir "$PATH_BEFORE_ACTUAL_DIR/$DATE/$LAST_DIR"
  CURRENT_PATH=$(echo $CURRENT_PATH | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo Current Path "$CURRENT_PATH"
  $MEGATOOLS_PATH copy --local "${CURRENT_PATH}" --remote "$PATH_BEFORE_ACTUAL_DIR/$DATE/$LAST_DIR"
done

#################################################
## New block of direct copy dirs which don't exist
exit
for CURRENT_PATH in ${PATHS_1}; do
  echo $CURRENT_PATH
  LAST_DIR=$(echo $CURRENT_PATH | awk -F "/" '{print $NF}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo Last dir: $LAST_DIR
  #$MEGATOOLS_PATH mkdir "$PATH_BEFORE_ACTUAL_DIR/$LAST_DIR"

  ### Cycle all dirs in folders

  #CURRENT_PATH=$(echo $CURRENT_PATH | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  echo Current Path "$CURRENT_PATH"
  #$MEGATOOLS_PATH copy --local "${CURRENT_PATH}" --remote "$PATH_BEFORE_ACTUAL_DIR/$DATE/$LAST_DIR"

done
exit
#################################################

IFS=${SAVEIFS}

SAVEIFS=${IFS}
IFS='
'
#exit
