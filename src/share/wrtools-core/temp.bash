# Copyright 2014 Georgia Tech Research Corporation (GTRC). All rights reserved.

# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.

# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.

# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.

if [[ is-set != "${WRTOOLS_LOADED_LIB_BASH_TEMP_BASH:+is-set}" ]]
then
  WRTOOLS_LOADED_LIB_BASH_TEMP_BASH=true

  . "$(dirname "$BASH_SOURCE")"/opt_verbose.bash
  . "$(dirname "$BASH_SOURCE")"/exit_hook.bash

  if [[ is-set != "${WRTOOLS_TEMP_DIR+is-set}" ]]
  then
    WRTOOLS_TEMP_DIR_V1=${TMPDIR:-/tmp}
    WRTOOLS_TEMP_DIR=${WRTOOLS_TEMP_DIR_V1%/}
    unset WRTOOLS_TEMP_DIR_V1
  fi

  #HELP:  --keep-temps | -k: Don't delete temporary files
  opt_keep_temps () {
      # we don't initialize this variable, because we want
      # temporary-file-keeping to propagate into subprocesses
      export WRTOOLS_TEMP_KEEP=true
  }

  WRTOOLS_TEMP_FILES=()
  WRTOOLS_TEMP_FILE_VARS=()
  
  # call with temp_make_file VARIABLE1 VARIABLE2 ...
  # and it'll make a temp file and set the value of VARIABLE1 to it, etc.
  temp_make_file () {
      local VAR
      for VAR in "$@"
      do
          local PATHNAME="$(umask 077; mktemp "$WRTOOLS_TEMP_DIR"/"$VAR".XXXXXX)"
          eval "$VAR"="$PATHNAME"
          # Append here; don't reset it, since this may be called multiple times.
          WRTOOLS_TEMP_FILE_VARS+=("$VAR")
          WRTOOLS_TEMP_FILES+=("$PATHNAME")
          vecho "make_temp_file(): $VAR=\"$PATHNAME\""
      done
  }

  WRTOOLS_TEMP_DIRS=()
  WRTOOLS_TEMP_DIR_VARS=()
  
  # call with temp_make_dir VARIABLE1 VARIABLE2 ...
  # and it'll make a temp dir and set the value of VARIABLE1 to it, etc.
  temp_make_dir () {
      local VAR
      for VAR in "$@"
      do
          local PATHNAME="$(umask 077; mktemp -d "$WRTOOLS_TEMP_DIR"/"$VAR".XXXXXX)"
          eval "$VAR"="$PATHNAME"
          # Append here; don't reset it, since this may be called multiple times.
          WRTOOLS_TEMP_DIR_VARS+=("$VAR")
          WRTOOLS_TEMP_DIRS+=("$PATHNAME")
          vecho "make_temp_dir(): $VAR=\"$PATHNAME\""
      done
  }

  temp_remove () {
      local KEY
      if [[ ! ${WRTOOLS_TEMP_KEEP:+is-set} ]]
      then
        # ICYMI, bash is evil: You get an unbound variable error
        # if you dereferece ${ARRAY[@]} after you set ARRAY=().
        if [[ ${#WRTOOLS_TEMP_FILES[@]} != 0 ]]
        then vrun rm -f "${WRTOOLS_TEMP_FILES[@]}"
             unset "${WRTOOLS_TEMP_FILE_VARS[@]}"
             WRTOOLS_TEMP_FILES=()
             WRTOOLS_TEMP_FILE_VARS=()
        fi
        if [[ ${#WRTOOLS_TEMP_DIRS[@]} != 0 ]]
        then vrun rm -rf "${WRTOOLS_TEMP_DIRS[@]}"
             unset "${WRTOOLS_TEMP_DIR_VARS[@]}"
             WRTOOLS_TEMP_DIRS=()
             WRTOOLS_TEMP_DIR_VARS=()
        fi
      else vecho "$(printf "Keeping temp files:"
                      for KEY in "${!WRTOOLS_TEMP_FILES[@]}"
                      do printf " %q=%q" "${WRTOOLS_TEMP_FILE_VARS[KEY]}" "${WRTOOLS_TEMP_FILES[KEY]}"
                      done
                      for KEY in "${!WRTOOLS_TEMP_DIRS[@]}"
                      do printf " %q=%q" "${WRTOOLS_TEMP_DIR_VARS[KEY]}" "${WRTOOLS_TEMP_DIRS[KEY]}"
                      done)"
      fi
  }

  add_exit_hook temp_remove

fi
