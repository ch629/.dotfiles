# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(git)

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

export PATH="$HOME/go/bin/:$PATH"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

alias nv="nvim ."
alias lg="lazygit"
alias oc="opencode"
alias l="eza -la"
alias ls="eza"
alias cat="bat"
alias gprv="gh pr view -w"
alias gmt="go mod tidy"
alias ga.="git add ."

# Handling nvim swapfiles
alias lsswap="ls -la ~/.local/state/nvim/swap"
alias rmswap="rm ~/.local/state/nvim/swap/*.swp"

alias k="kubectl"
alias glom="gl origin $(git_main_branch)"

export PATH="$HOME/.local/bin:$PATH"

export JAVA_HOME="/opt/homebrew/Cellar/openjdk@11/11.0.27/libexec/openjdk.jdk/Contents/Home"

function UUID() {
    echo $(uuidgen) | awk '{print tolower($0)}' | tr -d '\n' | pbcopy
}

alias uuid=UUID

alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

. "$HOME/.local/bin/env"

# opencode
export PATH=/Users/charliehowes/.opencode/bin:$PATH

eval "$(direnv hook zsh)"

export GOPRIVATE="github.com/betikake/"
export GPG_TTY=$(tty)

alias prnum="gh pr view --json number | jq '.number'"
alias prrepo="gh repo view --json nameWithOwner | jq '.nameWithOwner'"

# arctic
export PATH=/Users/charliehowes/.arctic/bin:$PATH
