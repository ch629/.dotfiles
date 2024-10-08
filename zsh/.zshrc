# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/.tokens

alias nv="nvim ."

# Loads dotenv variables as env vars & runs the provided command
#  eg: `de make run`
function de() {
    env $(cat .env|xargs) $@
}

alias lg="lazygit"
autoload -U compinit; compinit

export PATH="/Users/charliehowe/go/bin/:$PATH"

# Wasmer
export WASMER_DIR="/Users/charliehowe/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"
export LC_ALL=en_US.UTF-8

source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias l="exa -la"
alias ls="exa"
alias cat="bat"
alias gprv="gh pr view -w"

alias helmlogin="export HELM_EXPERIMENTAL_OCI=1 && gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin https://europe-docker.pkg.dev"

# Handling nvim swapfiles
alias lsswap="ls -la ~/.local/state/nvim/swap"
alias rmswap="rm ~/.local/state/nvim/swap/*.swp"

alias k="kubectl"
alias glom="gl origin $(git_main_branch)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/charliehowe/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
