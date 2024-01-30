#!/bin/sh
PATH=$(echo /usr/local/bin:/usr/bin)

###################################################
### function mkdir_p
_mega_mkdir_p() {

  MSP=$1 # Megatool Software Path
  USER=$2 # User login
  PWD=$3 # User password
  MUP=$4 # Megaupload path
  #  PATH_ARRAY=$(echo $MUP | tr "/" " ")
  PATH_ARRAY=$(echo "$MUP" | tr "/" "\n") #MEGA path splitted
  CUR_PATH=""

  echo PATH_ARRAY $PATH_ARRAY
  SAVEIFS=${IFS}
  IFS='
'
  for LAST_DIR in ${PATH_ARRAY}; do
    #IFS=${SAVEIFS}
    CUR_PATH="$CUR_PATH/$LAST_DIR"

    $MSP test -u "$USER" -p "$PWD" -d  --reload "/Root" ## Refresh cache
    $MSP test -u "$USER" -p "$PWD" -d "${CUR_PATH}"
    TEST="$?"
    echo test $TEST
    if [ "$TEST" = 0 -o $CUR_PATH = '/Root' ]; then
      echo Dir exists
    else
      echo Let\'s make $CUR_PATH
      echo $MSP mkdir -u "$USER" -p "$PWD" "$CUR_PATH"
      $MSP mkdir -u "$USER" -p "$PWD" "$CUR_PATH"
    fi

  done
  IFS=${SAVEIFS}
  echo $CUR_PATH
}
### /function mkdir_p
#############################################################
#_mkdir_p "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "/Root/Backup8/asss4_f"

###################################################
### function _mega_copy_if_not_exist
_mega_copy_if_not_exist() {
  MSP=$1 # Megatool Software Path
  USER=$2 # User login
  PWD=$3 # User password
  MUP=$4 # Megaupload path
  LPTH="$5" #Local Path 
  LSD="$6"  # Last dir, under which will be copy. Usually date.
  #echo $LSD LSD
  #  PATH_ARRAY=$(echo $MUP | tr "/" " ")
  PATH_ARRAY=$(echo "$MUP" | tr "/" "\n") #MEGA path splitted
  CUR_PATH=""

  echo PATH_ARRAY $PATH_ARRAY
  SAVEIFS=${IFS}
  IFS='
'
  for LAST_DIR in ${PATH_ARRAY}; do
    IFS=${SAVEIFS}
    echo LAST_DIR "$LAST_DIR"
    #IFS=${SAVEIFS}
    BEFORE_LAST="$CUR_PATH"
    CUR_PATH="$CUR_PATH/$LAST_DIR"
    echo Path $CUR_PATH
    $MSP test -u "$USER" -p "$PWD" -d  --reload "/Root" ## Refresh cache
    $MSP test -u "$USER" -p "$PWD" -d "${CUR_PATH}"
    TEST="$?"
    echo test $TEST
    if [ "$TEST" = 0 -o "$CUR_PATH" = '/Root' ]; then
      echo Dir exists
    else
      echo Let\'s copy $CUR_PATH
      echo BEFORE_LAST "${BEFORE_LAST}"
      $MSP mkdir -u "$USER" -p "$PWD" "${BEFORE_LAST}/${LAST_DIR}"
      echo copy --local "${LPTH}/${LAST_DIR}" --remote "${BEFORE_LAST}"
      $MSP copy -u "$USER" -p "$PWD" --local "${LPTH}/${LAST_DIR}" --remote "${BEFORE_LAST}/${LAST_DIR}"

    fi
  done
  if [ -n "$LSD"  -a "$CUR_PATH" = "$MUP" ]; then
      echo copy --local "${LPTH}" --remote "${BEFORE_LAST}"
      $MSP copy -u "$USER" -p "$PWD" --local "${LPTH}" --remote "${BEFORE_LAST}/${LAST_DIR}/${LSD}"
  else
      echo Nista!
  fi

  echo return CUR_PATH $CUR_PATH
  echo return BEFORE_LAST $BEFORE_LAST
}
### /function _mega_copy_if_not_exist
#############################################################
