# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

PATH=~/go/bin/:$PATH
PATH=~/.local/bin/:$PATH

ZSH_THEME="spaceship"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/.tokens

alias nv="nvim ."

# Loads dotenv variables as env vars & runs the provided command
#  eg: `de make run`
function de() {
    env $(cat .env|xargs) $@
}

# function gcb() {
#     for mergedBranch in $(git for-each-ref --format '%(refname:short)' --merged HEAD refs/heads/)
#     do
#         git branch -d ${mergedBranch}
#     done
# }

#

alias lg="lazygit"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/charliehowe/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)