
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

root_dir = tmp/prerequisites
override root_dir_abs = $(shell mkdir -p $(root_dir); cd $(root_dir); pwd)

packages = wrtools_core

repo_wrtools_core       = https://github.com/webb/wrtools-core.git

tokens_dir = tmp/tokens
synced_token_wrtools_core       = $(tokens_dir)/synced/wrtools_core
synced_tokens = $(synced_token_wrtools_core)

setup_token_wrtools_core       = $(tokens_dir)/setup/wrtools_core
setup_tokens = $(setup_token_wrtools_core)

repos_dir = tmp/repos
repo_dir_wrtools_core       = $(repos_dir)/wrtools_core.git

# invoke with $(call touch,$@)
touch = mkdir -p $(dir $(1)) && touch $(1)

all: $(setup_tokens)
	mkdir -p $(root_dir)

sync: $(synced_tokens)

resync:
	rm -f $(synced_tokens)
	$(MAKE) -f unconfigured.mk sync

#############################################################################
# wrtools-core

$(synced_token_wrtools_core):
	if [[ -d $(repo_dir_wrtools_core) ]]; \
	then cd $(repo_dir_wrtools_core); \
	     git pull; \
	else mkdir -p $(dir $(repo_dir_wrtools_core)); \
	     git clone $(repo_wrtools_core) $(repo_dir_wrtools_core); \
	fi
	$(call touch,$@)

$(setup_token_wrtools_core): $(synced_token_wrtools_core)
	cd $(repo_dir_wrtools_core); ./configure --prefix=$(root_dir_abs)
	make -C $(repo_dir_wrtools_core)
	make -C $(repo_dir_wrtools_core) install
	$(call touch,$@)

