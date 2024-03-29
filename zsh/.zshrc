# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh


# ZSH_THEME="spaceship"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting tmux)

source $ZSH/oh-my-zsh.sh
source ~/.tokens

alias nv="nvim ."

# Loads dotenv variables as env vars & runs the provided command
#  eg: `de make run`
function de() {
    env $(cat .env|xargs) $@
}

alias lg="lazygit"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/charliehowe/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
autoload -U compinit; compinit

export PATH="~/go/bin/:$PATH"

# Wasmer
export WASMER_DIR="/Users/charliehowe/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
export LC_ALL=en_US.UTF-8

source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
