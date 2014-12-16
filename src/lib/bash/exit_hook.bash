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

if [[ is-set != ${WRTOOLS_LOADED_EXIT_HOOK+is-set} ]]
then
  WRTOOLS_LOADED_EXIT_HOOK=true

  WRTOOLS_EXIT_HOOK=()
  add_exit_hook () {
      WRTOOLS_EXIT_HOOK+=( "$@" )
  }
  
  run_exit_hook () {
      # ${!Array[@]} won't crash out if "nounset" is on, whereas a
      # direct dereference will, if the array has no items
      local key
      for key in "${!WRTOOLS_EXIT_HOOK[@]}"
      do "${WRTOOLS_EXIT_HOOK[key]}"
      done
  }
  
  trap run_exit_hook 0

fi

