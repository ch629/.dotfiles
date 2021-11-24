# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

PATH=~/go/bin/:$PATH
PATH=~/.local/bin/:$PATH

ZSH_THEME="spaceship"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
