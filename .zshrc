source ~/.shell-aliases

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"

export PATH=/opt/homebrew/bin:$PATH

ZSH_THEME="powerlevel10k/powerlevel10k"

export ANDROID_HOME=/Users/bobbyechoprasetyo/Library/Android/sdk

export PATH=$ANDROID_HOME/platform-tools:$PATH

export PATH=$PATH:$ANDROID_HOME/emulator:$PATH/emulator

export PATH=$HOME/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export PATH="/Users/bobbyechoprasetyo/.jenv/shims:${PATH}"
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME

source '/opt/homebrew/Cellar/jenv/0.5.4/libexec/libexec/../completions/jenv.zsh'
jenv rehash 2>/dev/null
jenv refresh-plugins
source "/Users/bobbyechoprasetyo/.jenv/plugins/export/etc/jenv.d/init/export_jenv_hook.zsh"
jenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}
