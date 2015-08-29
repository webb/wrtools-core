WRTools-Core
=====

This package contains software supporting the development and execution of other
tools.

Copyright 2014-2015 Georgia Tech Research Corporation (GTRC). All rights
reserved.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>.

# Using the package

## `$prefix/share/wrtools/*.bash`

These scripts support writing bash scripts. Any function starting with `opt_`
("option...") was written to be called directly from a command-line parser.

This is a header for bash scripts that use these functions. Trim out whatever
you don't need:

```bash
#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

root_dir=$(dirname "$0")/..
. "$root_dir"/share/wrtools-core/opt_help.bash
. "$root_dir"/share/wrtools-core/opt_verbose.bash
. "$root_dir"/share/wrtools-core/fail.bash
. "$root_dir"/share/wrtools-core/temp.bash

#HELP:COMMAND_NAME: Perform a set of functions...
#HELP:Usage: COMMAND_NAME $string1 $string2 ...
```

`opt_help` will substitute the actual command name for COMMAND_NAME. Here's
sample help and command-line parsing for the included functions:

```bash
#HELP:Options:
#HELP:  --help | -h: Print this help
#HELP:  --keep-temps | -k: Don't delete temporary files
#HELP:  --verbose, -v: Print additional diagnostics

OPTIND=1
while getopts :hkv-: option
do
  case "$option" in
    h ) opt_help;;
    k ) opt_keep_temps;;
    v ) opt_verbose;;
    - ) case "$OPTARG" in
        help ) opt_help;;
        keep-temps ) opt_keep_temps;;
        verbose ) opt_verbose;;
        help=* | keep-temps=* | verbose=* )
          fail "Long option \"${OPTARG%%=*}\" has unexpected argument";;
        * ) fail "Unknown long option \"${OPTARG%%=*}\"";;
      esac;;
    '?' ) fail "Unknown short option \"$OPTARG\"";;
    : ) fail "Short option \"$OPTARG\" missing argument";;
    * ) fail_assert "Bad state in getopts (OPTARG=\"$OPTARG\")";;
  esac
done
shift $((OPTIND-1))
```

## `$prefix/share/wrtools-core/fail.bash`

### Function `fail_assert`

Check # of args for a function:

```bash
(( $# == 0 )) || fail_assert "$FUNCNAME expected 0 args, got $#"
```

or

```bash
(( $# == 1 )) || fail_assert "$FUNCNAME expected 1 args, got $#"
```

### Function `fail`

Check if a file is XML:

```bash
check-xml "$1" || fail "check-xml failed on file $1"
```

## `$prefix/share/wrtools-core/opt_help.bash`

Help entries in files look like this:

```bash
#HELP:  --help | -h: Print this help
```

### Function `opt_help`

This can be called by the command-line parser to print help and quit.

### Function `print_help`

This print help by scraping the lines containing `#HELP:` that appear in the
file from which it's invoked.

## `$prefix/share/wrtools-core/opt_verbose.bash`

Handle verbosity: extra debug output. The library starts out not being verbose

### Function `opt_verbose`

Turn on verbosity. Call from a command-line processor.

### Function `is_verbose`

Returns true if verbosity is turned on, false otherwise. Use like:

```bash
is_verbose && printf 'this is a problem\n' >&2
```

### Function `vecho`

"Verbose echo": like echo, but only prints if verbosity is turned on; sends
output to stderr.

### Function `vrun`

"Verbose run": run a command, and if verbosity is turned on then display info to
stderr.

## `$prefix/share/wrtools-core/temp.bash`

Create and remember temporary files and directories. These functions are wired
into opt_verbose, so it's easy to keep track of what's going on. These functions
depend on exit_hook, so don't use bash's `trap` command to trap signal 0
(EXIT). All temporary files and directories will be deleted when the script
exits.

### Function `opt_keep_temps`

Function `opt_keep_temps` prevents files and dirs from being deleted on exit.

### Function `temp_make_file`

Pass in a list of variable names. For each name passed in, it will create a
corresponding temporary file and will save the filename into the named
variable. For example:

```bash
temp_make_file HEADER
```

...will create a file and save it in the variable `HEADER`.

### Function `temp_make_dir`

Pass in a list of variable names. For each name passed in, it will create a
corresponding temporary directory and will save the pathname of the directory
into the named variable. For example:

```bash
temp_make_dir WORKING_DIR OUTPUT_DIR
```

...will create a temporary directory and save its path name in the variable
`WORKING_DIR`, it will and create another temporary directory and save its path
name in the variable `OUTPUT_DIR`.

## `$prefix/share/wrtools-core/exit_hook.bash`

Run some commands when the script exits

### Function `add_exit_hook`

Add commands to the list. These commands will be run when the script exits. For example:

```bash
do_thing_one () { ls /var/tmp; }
do_thing_two () { cat /etc/hosts; }
add_exit_hook do_thing_one do_thing_two
```

