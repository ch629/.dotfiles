# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source ~/.tokens

# Loads dotenv variables as env vars & runs the provided command
#  eg: `de make run`
function de() {
    env $(cat .env|xargs) $@
}


if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

source $ZSH/oh-my-zsh.sh

export PATH="/Users/charlie.howes/go/bin/:$PATH"
export PATH="$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin/:$PATH"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias nv="nvim ."
alias lg="lazygit"
alias l="eza -la"
alias ls="eza"
alias cat="bat"
alias gprv="gh pr view -w"
alias gmt="go mod tidy"
alias ga.="git add ."

alias helmlogin="export HELM_EXPERIMENTAL_OCI=1 && gcloud auth application-default print-access-token | helm registry login -u oauth2accesstoken --password-stdin europe-docker.pkg.dev"

# Handling nvim swapfiles
alias lsswap="ls -la ~/.local/state/nvim/swap"
alias rmswap="rm ~/.local/state/nvim/swap/*.swp"

alias k="kubectl"
alias glom="gl origin $(git_main_branch)"

export PATH="/Users/charlie.howes/.local/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/charlie.howes/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.27/libexec/openjdk.jdk/Contents/Home"

function UUID() {
    echo $(uuidgen) | awk '{print tolower($0)}' | tr -d '\n' | pbcopy
}

alias uuid=UUID
