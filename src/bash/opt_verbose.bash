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

# recommended help:
#HELP:  --verbose, -v: Print additional diagnostics

# getopts pieces:
#while getopts :v-: option
#       v ) opt_verbose;;
#       - ) case "$OPTARG" in
#               verbose ) opt_verbose;;
#               verbose=* ) fail "Long option \"${OPTARG%%=*}\" has unexpected argument";;


if test is-set != "${WRTOOLS_LOADED_OPT_VERBOSE_BASH+is-set}"
then
  WRTOOLS_LOADED_OPT_VERBOSE_BASH=true

  # use caution when combining this library with pipelines.
  # Pipelines are asynchronous, and verbosity / debugging output can
  # overlap in strange, sometimes painfully unfortunate ways.

  . "CONFIG_BASH_DIR"/common.bash
  . "CONFIG_BASH_DIR"/command-path.bash

  unset WRTOOLS_VERBOSE
  opt_verbose () {
      export WRTOOLS_VERBOSE=true
  }

  is_verbose () {
      [[ is-set = ${WRTOOLS_VERBOSE+is-set} ]]
  }

  vecho () {
      if is_verbose
      then printf "# %s: %s\n" "$(get_command_path_short)" "$*" >&2
      fi
  }

  vrun () {
      if is_verbose
      then { printf "# %s: running " "$(get_command_path_short)"
             printf " \"%s\"" "$@"
             printf "\n"; } >&2
      fi
      "$@"
  }

fi

