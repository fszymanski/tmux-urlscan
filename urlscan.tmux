#!/usr/bin/env bash

# Copyright (c) 2018 Filip Szymański. All rights reserved.
# Use of this source code is governed by an MIT license that can be
# found in the LICENSE file.

set -euf -o pipefail

get_tmux_option() { # {{{
  local option=$1
  local option_value=$(tmux show-option -gqv "$option")
  local default_value=$2
  if [[ -z "$option_value" ]]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
} # }}}

command_exists() { # {{{
  command -v "$1" &> /dev/null
} # }}}

readonly args=$(get_tmux_option "@urlscan-args" "-c -d")
readonly key=$(get_tmux_option "@urlscan-key" "u")

main() { # {{{
  if command_exists urlscan; then
    tmux bind-key "$key" capture-pane -J \\\; \
      save-buffer "${TMPDIR:-/tmp}/tmux-urlscan-buffer" \\\; \
      split-window -p 40 "urlscan $args ${TMPDIR:-/tmp}/tmux-urlscan-buffer"
  else
    tmux display-message "urlscan: command not found, see: https://github.com/firecat53/urlscan"
  fi
} # }}}
main

# vim: sw=2 ts=2 et fdm=marker