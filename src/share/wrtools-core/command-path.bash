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

if test is-set != "${WRTOOLS_LOADED_COMMAND_PATH_BASH:+is-set}"
then
  WRTOOLS_LOADED_COMMAND_PATH_BASH=true

  # Don't reference these. Use the functions instead.
  # We can optimize this out later if needed
  WRTOOLS_COMMAND_PATH_BASH_SHORT_VALUE=$(basename "$0")

  WRTOOLS_COMMAND_PATH_BASH_ABS_VALUE=$(cd "$(dirname "$0")"; pwd)/$WRTOOLS_COMMAND_PATH_BASH_SHORT_VALUE
  get_command_path_abs () {
      if [[ is-set != ${WRTOOLS_COMMAND_PATH_BASH_ABS_VALUE+is-set} ]]
      then WRTOOLS_COMMAND_PATH_BASH_ABS_VALUE=$(cd "$(dirname "$0")"; pwd)/$WRTOOLS_COMMAND_PATH_BASH_SHORT_VALUE
      fi
      printf "%s" "$WRTOOLS_COMMAND_PATH_BASH_ABS_VALUE"
  }

  get_command_path_short () {
      printf "%s" "$WRTOOLS_COMMAND_PATH_BASH_SHORT_VALUE"
  }

fi

