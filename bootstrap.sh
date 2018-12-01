#!/bin/bash

#-----------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------

# Notice title

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

backup() {
  mkdir -p $backupdir

  local files=( $(ls -a) )
  for file in "${files[@]}"; do
    in_array $file "${excluded[@]}" || cp -Rf "$HOME/$file" "$backupdir/$file"
  done
}

install() {
  local files=( $(ls -a) )
  for file in "${files[@]}"; do
    in_array $file "${excluded[@]}"
    should_install=$?
    if [ $should_install -gt 0 ]; then
      [ -d "$HOME/$file" ] && rm -rf "$HOME/$file"
      cp -Rf "$file" "$HOME/$file"
    fi
  done
}

in_array() {
  local hay needle=$1
  shift
  for hay; do
    [[ $hay == $needle ]] && return 0
  done
  return 1
}


#-----------------------------------------------------------------------------
# Initialize
#-----------------------------------------------------------------------------

backupdir="$HOME/.dotfiles-backup/$(date "+%Y%m%d%H%M.%S")"
excluded=(. .. .git .gitignore bootstrap.sh Brewfile README.md)


#-----------------------------------------------------------------------------
# Install
#-----------------------------------------------------------------------------

# Backup
#info "Backup up old files ($backupdir)"
#backup

# Install
info "Installing"
install


#-----------------------------------------------------------------------------
# Homebrew
#-----------------------------------------------------------------------------

if [ "$(uname -s)" == "Darwin" ]
then
  info "installing dependencies"

  # Install and setup homebrew
  if test ! $(which brew)
  then
    echo "  Installing Homebrew for you."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo "› brew update"
  brew update

  # Run Homebrew through the Brewfile
  echo "› brew bundle"
  brew bundle

  echo "› brew cleanup"
  brew cleanup

  success "dependencies installed"
fi


#-----------------------------------------------------------------------------
# Finished
#-----------------------------------------------------------------------------

echo ''
echo '  All installed!'
exec $SHELL -l
