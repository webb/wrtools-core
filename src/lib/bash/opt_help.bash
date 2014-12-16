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

if test is-set != "${WRTOOLS_LOADED_OPT_HELP_BASH:+is-set}"
then
  WRTOOLS_LOADED_OPT_HELP_BASH=true

  . CONFIG_PREFIX/lib/bash/command-path.bash

  # Use command line help:
  #    #HELP:  --help | -h: Print this help
  # macro COMMAND_NAME will substitute for the short name of the command
  opt_help () {
      (( $# == 0 )) || {
          printf "%s:%d: Error: function %s must have 0 arguments (got %d)\n" "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "${FUNCNAME[0]}" $# >&2
          exit 1
      }
      'CONFIG_SED_COMMAND' -e "s/.*#""HELP://p;d" "$(get_command_path_abs)" | 'CONFIG_M4_COMMAND' -P -DCOMMAND_NAME="$(get_command_path_short)"
        exit 0
    }
fi

