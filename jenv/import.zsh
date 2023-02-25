export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export PATH="$HOME/.jenv/shims:${PATH}"
export JENV_SHELL=zsh
export JENV_LOADED=1

source '/opt/homebrew/Cellar/jenv/0.5.4/libexec/libexec/../completions/jenv.zsh'
source "$HOME/.jenv/plugins/export/etc/jenv.d/init/export_jenv_hook.zsh"

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


jenv rehash 2>/dev/null
jenv refresh-plugins
