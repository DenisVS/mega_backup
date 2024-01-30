#!/bin/sh
PATH=$(echo /usr/local/bin:/usr/bin)

###################################################
### function mkdir_p
_mega_mkdir_p() {

  MT_PATH=$1
  UNAME=$2
  PSSWD=$3
  DIRN=$4
  #  PATH_ARRAY=$(echo $DIRN | tr "/" " ")
  PATH_ARRAY=$(echo "$DIRN" | tr "/" "\n") #MEGA path splitted
  PATH=""

  echo PATH_ARRAY $PATH_ARRAY
  SAVEIFS=${IFS}
  IFS='
'
  for LAST_DIR in ${PATH_ARRAY}; do
    #IFS=${SAVEIFS}
    PATH="$PATH/$LAST_DIR"

    $MT_PATH test -u "$UNAME" -p "$PSSWD" -d  --reload "/Root" ## Refresh cache
    $MT_PATH test -u "$UNAME" -p "$PSSWD" -d "${PATH}"
    TEST="$?"
    echo test $TEST
    if [ "$TEST" = 0 -o $PATH = '/Root' ]; then
      echo Dir exists
    else
      echo Let\'s make $PATH
      echo $MT_PATH mkdir -u "$UNAME" -p "$PSSWD" "$PATH"
      $MT_PATH mkdir -u "$UNAME" -p "$PSSWD" "$PATH"
    fi

  done
  IFS=${SAVEIFS}
  echo $PATH
}
### /function mkdir_p
#############################################################
#_mkdir_p "$MEGATOOLS_PATH" "$USERNAME" "$PASSWORD" "/Root/Backup8/asss4_f"

###################################################
### function _mega_copy_if_not_exist
_mega_copy_if_not_exist() {

  MT_PATH=$1
  UNAME=$2
  PSSWD=$3
  DIRN="$4"
  DIRL="$5"
  LSDIR="$6"
  #echo $LSDIR LSDIR
  #  PATH_ARRAY=$(echo $DIRN | tr "/" " ")
  PATH_ARRAY=$(echo "$DIRN" | tr "/" "\n") #MEGA path splitted
  PATH=""

  echo PATH_ARRAY $PATH_ARRAY
  SAVEIFS=${IFS}
  IFS='
'
  for LAST_DIR in ${PATH_ARRAY}; do
    IFS=${SAVEIFS}
    echo LAST_DIR "$LAST_DIR"
    #IFS=${SAVEIFS}
    BEFORE_LAST="$PATH"
    PATH="$PATH/$LAST_DIR"
    echo Path $PATH
    $MT_PATH test -u "$UNAME" -p "$PSSWD" -d  --reload "/Root" ## Refresh cache
    $MT_PATH test -u "$UNAME" -p "$PSSWD" -d "${PATH}"
    TEST="$?"
    echo test $TEST
    if [ "$TEST" = 0 -o "$PATH" = '/Root' ]; then
      echo Dir exists
    else
      echo Let\'s copy $PATH
      echo BEFORE_LAST "${BEFORE_LAST}"
      $MT_PATH mkdir -u "$UNAME" -p "$PSSWD" "${BEFORE_LAST}/${LAST_DIR}"
      echo copy --local "${DIRL}/${LAST_DIR}" --remote "${BEFORE_LAST}"
      $MT_PATH copy -u "$UNAME" -p "$PSSWD" --local "${DIRL}/${LAST_DIR}" --remote "${BEFORE_LAST}/${LAST_DIR}"

    fi

  done
  if [ -n "$LSDIR"  -a "$PATH" = "$DIRN" ]; then
      echo copy --local "${DIRL}" --remote "${BEFORE_LAST}"
      $MT_PATH copy -u "$UNAME" -p "$PSSWD" --local "${DIRL}" --remote "${BEFORE_LAST}/${LAST_DIR}/${LSDIR}"
  else
      echo Nista!
  fi


  

  echo return PATH $PATH
  echo return BEFORE_LAST $BEFORE_LAST
}
### /function _mega_copy_if_not_exist
#############################################################
