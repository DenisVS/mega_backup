#!/bin/sh
PATH=$(echo /usr/local/bin:/usr/bin)

###################################################
### function mkdir_p
_mega_mkdir_p() {

  MSP=$1  # Megatool Software Path
  USER=$2 # User login
  PWD=$3  # User password
  MUP=$4  # Megaupload path
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
_mega_copy_if_not_exist_BAK() {
  MSP=$1    # Megatool Software Path
  USER=$2   # User login
  PWD=$3    # User password
  MUP=$4    # Megaupload path
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
  if [ -n "$LSD" -a "$CUR_PATH" = "$MUP" ]; then
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

###################################################
### function _mega_copyfile_if_not_exist
_mega_copy_if_not_exist() {
  MSP=$1      # Megatool Software Path
  USER=$2     # User login
  PWD=$3      # User password
  MUP=$4      # Megaupload path
  LPTH="$5"   #Local Path
  LSD="$6"    # Last element of path, usually dir as date, under which will copy, or file, if option 3 to copy files
  OPTION="$7" # OPTIONS

  echo $LSD LSD
  echo $OPTION OPTION
  echo $MUP MUP
  echo $LPTH LPTH

  #exit
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
  ### CLAUSE copy file if option and ... (find what is it)
  if [ -n "$LSD" -a "$CUR_PATH" = "$MUP" -a "$OPTION" = "1" ]; then
    echo Its files!

    #LSD file
    #MUP remotepath
    #LPTH localpath
    #

    # does the file exist?
    $MSP test -u "$USER" -p "$PWD" -f "${MUP}/${LSD}"
    TEST="$?"
    echo test $TEST
    if [ "$TEST" = 0 ]; then
      echo File exists
    else
      echo Let\'s copy ${LSD}
      echo BEFORE_LAST "${BEFORE_LAST}"
      # megatools put [--no-progress] [--path <remotepath>] <paths>
      # megatools put [--no-progress] [--path <remotepath>] <file(s)>
      $MSP put -u "$USER" -p "$PWD" --path "${MUP}" "${LPTH}/${LSD}"

    fi

    #exit
  else
    # If Last dir exist & Path = Megaupload path
    if [ -n "$LSD" -a "$CUR_PATH" = "$MUP" ]; then
      echo copy --local "${LPTH}" --remote "${BEFORE_LAST}"
      $MSP copy -u "$USER" -p "$PWD" --local "${LPTH}" --remote "${BEFORE_LAST}/${LAST_DIR}/${LSD}"
    else
      echo Nista!
    fi
  fi

  echo return CUR_PATH $CUR_PATH
  echo return BEFORE_LAST $BEFORE_LAST
}
### /function _mega_copyfile_if_not_exist
#############################################################






_mega_find_files() {
  WHERE_TO_FIND="$1"
  echo $WHERE_TO_FIND AAAAA
  find "$ELEMENT_LOCAL_PATH" -maxdepth 1 -mindepth 1 -type f | awk -F \/ '{print $NF}'
  #RESULT="$WHERE_TO_FIND AAAAA"
}
