
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

default:
	@ printf "No default target. Targets:\n"
	@ printf "    zero: remove everything that can be generated\n"
	@ printf "    init: create everything that can be generated pre-configure\n"

zero:
	$(RM) -r .gradle autom4te.cache out
	$(RM) Makefile autm4te.cache autoscan.log config.log configure 
	$(RM) config.guess config.sub config.status install-sh ltmain.sh
	$(RM) depcomp missing aclocal.m4 
	find . -type f -name '*~' -delete

install-sh:
	glibtoolize -icf
	$(RM) ltmain.sh config.guess config.sub

init: install-sh
	autoreconf --install --verbose
