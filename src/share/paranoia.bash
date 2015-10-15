# Copyright 2015 Georgia Tech Research Corporation (GTRC). All rights reserved.

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
#HELP:  --not-paranoid: Omit basic/foundational validations

# there's not a recommended short-form for the not-paranoid option. Make them spell it out.

# getopts pieces:
#       - ) case "$OPTARG" in
#               not-paranoid ) opt_not_paranoid;;
#               not-paranoid=* ) fail "Long option \"${OPTARG%%=*}\" has unexpected argument";;

if test is-set != "${WRTOOLS_LOADED_PARANOIA_BASH+is-set}"
then
  WRTOOLS_LOADED_PARANOIA_BASH=true

  # We do not want not-paranoia to propagate into subprocesses; we want to fall
  # back to paranoid unless it is deliberately overridden.

  unset WRTOOLS_PARANOIA_NOT_PARANOID
  
  opt_not_paranoid () {
      export WRTOOLS_PARANOIA_NOT_PARANOID=true
  }

  # negate with !, e.g.: ! is_paranoid || [[ -r $file ]] || fail "file is not readable: $file"
  is_paranoid () {
      [[ ${WRTOOLS_PARANOIA_NOT_PARANOID-false} != true ]]
  }

fi

