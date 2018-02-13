# Path to dotfiles
DOTFILE_PATH=$HOME/.dotfiles
SCRIPTS_PATH=$DOTFILE_PATH/scripts
ZSH_CONFIG_PATH=$DOTFILE_PATH/zsh

ZSH_THEME="afowler"
plugins=(git colored-man-pages z)

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh


unamestr=`uname`

# Load ZSHRC config
source $ZSH_CONFIG_PATH/all_zshrc.conf

# MacOS configs
if [[ "$unamestr" == "Darwin" ]]; then
    source $ZSH_CONFIG_PATH/darwin_zshrc.conf
else
# Linux configs
    source $ZSH_CONFIG_PATH/linux_zshrc.conf
    # Docker configs
    if [ -f /.dockerenv ]; then
        source $ZSH_CONFIG_PATH/docker_zshrc.conf
    fi
fi
