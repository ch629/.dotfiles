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
