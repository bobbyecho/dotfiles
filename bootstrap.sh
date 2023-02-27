#!/bin/bash

# cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)
SHELL_EXTENDER=".shell_extender"
mkdir -p "$HOME/$SHELL_EXTENDER"

set -e

function skip () {
  printf "\r  [ \033[00;34mSKIP\033[0m ] $1\n"
}

function install () {
  printf "\r  [ \033[0;33mINSTALL\033[0m ] $1\n"
}

function user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

function success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

function havecmd() {
  # extends command -v to optionally (set $HAVECMD_REPORT) report errors
  # Often used like:
  # havecmd some_command || exit $?
  # To exit in my shell scripts if a required command isn't found

  BINARY="${1:?Must provide command to check}"
  if [[ -z "$(command -v $BINARY)" ]]; then
    echo false
  else
    echo true
  fi
}

function install_brew() {
  if [ "$(havecmd brew)" = true ]; then
    skip "binary brew already exists"        
  else
    install "installing brew..."
    sh $DOTFILES/brew/install.sh &> /dev/null
    success "brew successfully installed"
  fi
}

function install_nvm() {
  if [ -d "${HOME}/.nvm/.git" ]; then
    skip "binary nvm already exists"        
  else
    install "installing nvm..."
    sh $DOTFILES/nvm/install.sh &> /dev/null
    success "nvm successfully installed"
  fi
}

function install_zsh_auto_autosuggestions() {
  if [ -d "${HOME}/.zsh/zsh-autosuggestions" ]; then
    skip "zsh-autosuggestions already exists"        
  else
    install "installing zsh-autosuggestions..."
    sh $DOTFILES/zsh-autosuggestions/install.sh &> /dev/null
    success "zsh-autosuggestions successfully installed"
  fi
}

function install_zsh_syntax_highlighting() {
  if [ -d "${HOME}/.zsh/zsh-syntax-highlighting" ]; then
    skip "zsh-syntax-highlighting already exists"        
  else
    install "installing zsh-syntax-highlighting..."
    sh $DOTFILES/zsh-syntax-highlighting/install.sh &> /dev/null
    success "zsh-syntax-highlighting successfully installed"
  fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite=
  local backup=
  local skip=
  local action=
  local currentSrc=

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      # ignoring exit 1 from readlink in case where file already exists
      # shellcheck disable=SC2155
      currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action  < /dev/tty

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      skip "skipped link $src => $dst"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

# some libs must to be installed by hand rather inside loop function
# - brew (must install first)
# - nvm
# - zsh-autosuggestion
# - zsh-syntax-highlighting
# 
# adding `-not -path` in install libraries section if lib have to be install manually
run () {
  local overwrite_all=false backup_all=false skip_all=false

  install_brew
  install_nvm
  install_zsh_auto_autosuggestions
  install_zsh_syntax_highlighting

  # install libraries
  find -H "$DOTFILES" -type f -maxdepth 2 \
  -not -path '*.git*' \
  -not -path '*brew*' \
  -not -path '*nvm*' \
  -not -path '*zsh-autosuggestions*' \
  -not -path '*zsh-syntax-highlighting*' \
  -name 'install.sh' | while read filesrc
  do
    dir_name=$(dirname $filesrc)
    ignore_check_exists=$(find -H ${dir_name} -name 'ignore-check')
    if [[ -z $ignore_check_exists ]]
    then
      base_name="$(basename $dir_name)"
      if [ "$(havecmd $base_name)" = true ]; then
        skip "binary ${base_name} already exists"        
      else
        install "installing $base_name..."
        sh $filesrc &> /dev/null
        success "$base_name sucessfully installed"
      fi
    fi
  done

  # manage rc files
  find -H "$DOTFILES" -maxdepth 2 -name 'symlink' -not -path '*.git*' | while read linkfile
  do
    cat "$linkfile" | while read line
    do
        local src dst
        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)

        link_file "$src" "$dst"
    done
  done
}

run

exec $SHELL -l
