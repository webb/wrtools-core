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

if [[ is-set != ${WRTOOLS_LOADED_LIB_BASH_FAIL_BASH:+is-set} ]]
then
  WRTOOLS_LOADED_LIB_BASH_FAIL_BASH=true

  . "$(dirname "$BASH_SOURCE")"/command-path.bash
  
  # use fail for user-facing stuff
  # use fail_assert for errors that are not user-facing. Provides more detail
  
  fail () {
      printf "%s: Error: %s\n" "$(get_command_path_short)" "$*" >&2
      exit 1
  }
  
  print_fail () {
      printf "%s: Error: %s\n" "$(get_command_path_short)" "$*" >&2
  }

  # fail_later() and maybe_fail_now(): aggregate multiple possible errors before failing
  # - fail_later(): call like you call fail(): provide an error message and set an error condition.
  # - maybe_fail_now(): quits if there was error earlier.
  # Good for making several checks, with diagnostics, before quitting.
  
  unset WRTOOLS_FAIL_BASH_FAILED
  fail_later () {
      printf "%s: Error: %s\n" "$(get_command_path_short)" "$*" >&2
      WRTOOLS_FAIL_BASH_FAILED=true
  }
      
  maybe_fail_now () {
      (( $# == 0 )) || fail_assert "$FUNCNAME requires 0 args (got $#)"
      if [[ ${WRTOOLS_FAIL_BASH_FAILED+is-set} = is-set ]]
      then exit 1
      fi
  }
  
  warn () {
      printf "%s: Warning: %s\n" "$(get_command_path_short)" "$*" >&2
  }
  
  fail_assert () {
      printf "%s: Error: %s\n" "$(get_command_path_abs)" "$*" >&2
      local i
      for (( i = 1; i <= ${#BASH_SOURCE[@]}; ++i ))
      do
          printf "  called from %s:%d: function %s\n" "${BASH_SOURCE[i]}" "${BASH_LINENO[i - 1]}" "${FUNCNAME[i - 1]}" >&2
      done
      exit 1
  }

  # CALL AS: fail_arg_unexpected "$OPTARG"
  # CALL AS: fail_arg_unexpected help=true
  fail_arg_unexpected () {
      (( $# == 1 )) || fail_assert "$FUNCNAME requires 1 arg (got $#)"
      fail "Option \"${1%%=*}\" has unexpected argument"
  }
      
  # CALL AS: fail_arg_missing "$OPTARG"
  # CALL AS: fail_arg_missing remote
  fail_arg_missing () {
      (( $# == 1 )) || fail_assert "$FUNCNAME requires 1 arg (got $#)"
      fail "Option \"$1\" is missing required argument"
  }

  # CALL AS: fail_option_missing "$option"
  # CALL AS: fail_option_missing --verbose
  fail_option_missing () {
      (( $# == 1 )) || fail_assert "$FUNCNAME requires 1 arg (got $#)"
      fail "Option \"$1\" is required but absent"
  }

  # CALL AS: fail_option_unknown "$OPTARG"
  fail_option_unknown () {
      (( $# == 1 )) || fail_assert "$FUNCNAME requires 1 arg (got $#)"
      fail "Unknown option \"${1%%=*}\""
  }

fi

