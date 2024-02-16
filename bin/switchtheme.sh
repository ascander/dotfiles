#!/usr/bin/env bash

# switchtheme.sh - switch Alacritty theme
#
# Description:
#
# This script switches the current Alacritty theme by rewriting
# `alacritty.toml` to import the desired color theme file. Color theme files
# are in `config/alacritty/themes` and the Alacritty config file is in
# `config/alacritty/alacritty.toml`.
#
# Usage:
#
#   switchtheme.sh [OPTIONS] THEME_NAME
#
# Options:
#
#   -h
#
#     Prints usage information
#
#   -l
#
#     List all available themes.
#
#   -f
#
#     Delete the backup Alacritty config file after updating.
#
# Examples:
#
#   List available themes:
#
#     switchtheme.sh -l
#
#   Change theme to 'nordfox':
#
#     switchtheme.sh nordfox
#
#   Change theme to 'rose-pine-moon' without creating a backup:
#
#     switchtheme.sh -f rose-pine-moon

# Sane behavior
set -euo pipefail

# Global vars
DELETE_BACKUP=0
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ALACRITTY_CONFIG_DIR="${SCRIPT_DIR/%bin/config/alacritty}"
ALACRITTY_THEMES_DIR="${ALACRITTY_CONFIG_DIR}/themes"

# Print usage information
usage() {
  echo "Switch Alacritty color theme"
  echo ""
  echo "Usage:"
  echo "  $(basename "$0") [OPTIONS] THEME"
  echo ""
  echo "Options:"
  echo "  -h  Display this message"
  echo "  -l  List available themes"
  echo "  -f  Delete backup Alacritty config file"
}

# List available themes
list_themes() {
  local available_themes=()
  for file in `ls "$ALACRITTY_THEMES_DIR"`; do
    available_themes+=( "${file%.toml}" )
  done

  echo "Available themes:"
  echo ""
  for theme in "${available_themes[@]}"; do
    echo "  ${theme}"
  done
}

# Main function
main() {
  while getopts "hlf" opt; do
    case "$opt" in
      l)
        list_themes
        exit;;
      f)
        DELETE_BACKUP=1;;
      h | *)
        usage
        exit;;
    esac
  done
  shift $((OPTIND-1))

  local alacritty_config_file="${ALACRITTY_CONFIG_DIR}/alacritty.toml" # the config file
  local desired_theme="$1"                                             # the theme you want
  local available_themes=()                                            # init available themes array

  # Collect available themes
  for file in `ls "$ALACRITTY_THEMES_DIR"`; do
    available_themes+=( "${file%.toml}" )
  done

  # Validate desired theme
  if [[ ! " ${available_themes[@]} " =~ [[:space:]]${desired_theme}[[:space:]] ]]; then
    echo "Unrecognized theme: ${desired_theme}. Exiting."
    exit 1
  fi

  # Update config file
  sed -i'.bk' -r "s/(themes\/)[a-z_-]+(\.toml)/\1${desired_theme}\2/" "$alacritty_config_file"

  # Cleanup if requested
  if [[ $DELETE_BACKUP -gt 0 ]]; then
    [ ! -s "${alacritty_config_file}.bk" ] || rm -f "${alacritty_config_file}.bk"
  fi
}

main "$@"
