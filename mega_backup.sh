#!/bin/sh
MEGATOOLS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/megatools.exe'
MEGA_CREDENTIALS_PATH='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega.ini'
MEGA_BACKUP_PATHS='/cygdrive/c/PF/megatools-1.11.1.20230212-win64/mega_server_backup_paths.ini'
MEGA_CLOUD_PATH="/Root/Backups/ServerModularWin"

DATE=$(date "+%Y%m%d_%H%M")
USERNAME=$(cat "$MEGA_CREDENTIALS_PATH" | grep Username | awk -F \= '{print $2}')
PASSWORD=$(cat "$MEGA_CREDENTIALS_PATH" | grep Password | awk -F \= '{print $2}')

GGGH=""
mails=$(echo $MEGA_CLOUD_PATH | tr "/" " ")
for HUGF in ${mails}; do
  #echo "$HUGF" SSSS
  GGGH="$GGGH/$HUGF"
  #echo $GGGH
  $MEGATOOLS_PATH mkdir "$GGGH"

done
$MEGATOOLS_PATH mkdir "$GGGH/$DATE"
PATHS=$(cat $MEGA_BACKUP_PATHS)
SAVEIFS=${IFS}
IFS='
'

for CURRENT_PATH in ${PATHS}; do
  echo $CURRENT_PATH
  LAST_DIR=$(echo $CURRENT_PATH | awk -F "/" '{print $NF}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  $MEGATOOLS_PATH mkdir "$GGGH/$DATE/$LAST_DIR"

  CURRENT_PATH=$(echo $CURRENT_PATH | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  echo "$CURRENT_PATH"

  $MEGATOOLS_PATH copy --local "${CURRENT_PATH}" --remote "$GGGH/$DATE/$LAST_DIR"

done

IFS=${SAVEIFS}
