# Path to oh-my-zsh installation.

ZSH_THEME="afowler"
plugins=(git colored-man-pages z)
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# FZF config file
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export COPYFILE_DISABLE=true
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export PYTHONSTARTUP=~/.pythonrc

alias c="clear"

unamestr=`uname`
# MacOS configs
if [[ "$unamestr" == "Darwin" ]]; then
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/Users/fr0zn/go/bin"
    # Android sdk and ndk
    export PATH=$PATH:/Users/fr0zn/sdk/platform-tools:/Users/fr0zn/sdk/ndk-bundle:/Users/fr0zn/sdk/tools:/Users/fr0zn/sdk/tools/bin
    export ANDROID_HOME=/usr/local/opt/android-sdk
    alias rm="trash"
    alias service="brew services"
    alias mount="diskutil mount"
    alias umount="diskutil umountDisk"
    export EDITOR='vim'
    # Used for NerdCommander
    alias open='open -R'
    alias saver='/usr/local/Cellar/pipes-sh/1.2.0/bin/pipes.sh'
    alias ninja='/Applications/Binary\ Ninja.app/Contents/MacOS/binaryninja'
    #export XML_CATALOG_FILES="/usr/local/etc/xml/catalog"
    # Open man page as PDF
    function manpdf() {
        man -t "${1}" | open -f -a /Applications/Preview.app/
    }
    alias ls='exa'
    alias ll='exa --long -B -U'
    alias la='exa --long -B -U -a'

    alias todo='todoist --color'
else
# Linux configs
    alias rm="rm -i"
    export EDITOR='vim'
fi

# Set docker hostname to distinguish between host and container
if [ -f /.dockerenv ]; then
    PROMPT='%{$fg_bold[green]%}%M: %{$reset_color%}%{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%}%{$GIT_PROMPT_INFO%}$(git_prompt_info)$(virtualenv_prompt_info)%{$GIT_DIRTY_COLOR%}$(git_prompt_status) %{$reset_color%}%{$PROMPT_PROMPT%}ᐅ%{$reset_color%} '
fi

# https://unix.stackexchange.com/questions/1045/getting-256-colors-to-work-in-tmux
alias tmux='tmux -2'

alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
# alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'

function mkctf(){
    mkdir exploiting
    mkdir crypto
    mkdir web
    mkdir reversing
    mkdir forensic
    mkdir misc
}

function rfc (){
    url="https://www.ietf.org/rfc"
    if [[ -z $1 ]]; then
        echo "RFC no specified"
    else
        b=$(curl -LsD h $url/rfc$1.txt)
        h=$(<h)
        echo $h | grep '200 OK' > /dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo $b | less
        else
            echo "RFC not found"
        fi
    fi
}

alias server='python -m SimpleHTTPServer'

function extract_shellcode(){
    if [[ -z $1 ]]; then
        echo "Usage extract_shellcode binary_file"
    else
        for i in $(objdump -d $1 -M intel |grep "^ " |cut -f2); do echo -n '\x'$i; done;echo
    fi
}

function docker-start(){
    eval $(docker-machine env default)
}

function docker-stop(){
    unset DOCKER_TLS
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset DOCKER_MACHINE_NAME
}

#Create a new directory and enter it
function mk() {
    mkdir -p "$1" && cd "$1"
}

function box(){
    ESC="\x1B["
    RESET=$ESC"39m"
    RED=$ESC"31m"
    GREEN=$ESC"32m"
    BLUE=$ESC"34m"

    if [[ -z ${1} ]]; then
        echo -e "${RED}Missing argument box name.${RESET}"
        echo -e "Usage: $0 name [-r][-v path]."
    else

        box_name=${1}
        case $box_name in
            [^a-zA-Z0-9]* ) echo "Name not ok : should start with [a-zA-Z0-9], got $box_name"
            echo -e "Usage: $0 name [-r][-v path]."
            return
            ;;
            *[^a-zA-Z0-9_.-]* ) echo "Name not ok : special character not allowed, only [a-zA-Z0-9_.-] got $box_name"
            echo -e "Usage: $0 name [-r][-v path]."
            return
            ;;
        esac

        # start docker env
        eval $(docker-machine env default)
        # Check if container is already running
        is_present=`docker ps -aqf "name=${box_name}"`
        if [[ ! -z $is_present ]]; then
            # If container exists, then start it
            echo -e "${BLUE}${box_name} is already present, starting it${RESET}"
            docker start ${box_name} &> /dev/null
        else

            RM=""
            SHARE_PATH=""
            OPTIND=2
            while getopts ":r :v:" opt; do
              case $opt in
                r)
                  RM="--rm"
                  ;;
                v)
                  SHARE_PATH=$(cd ${OPTARG} && pwd)
                  if [[ $? != 0 ]]; then
                    return
                  fi
                  ;;
                \?)
                  echo "Invalid option: -$OPTARG" >&2
                  ;;
              esac
            done

            echo -e "${BLUE}Creating container: $box_name${RESET}"
            SHARE_CMD=""
            if [[ ! -z $SHARE_PATH ]]; then
                echo -e "${BLUE}Sharing path: $SHARE_PATH${RESET}"
                SHARE_CMD=$(echo -e "-v$SHARE_PATH:/root/files")
            fi
            if [[ ! -z $RM ]]; then
                echo -e "${RED}This container will be removed after exiting${RESET}"
            fi

            # Create docker container and run in the background
            docker run --privileged -it \
                $RM\
                $SHARE_CMD\
                -d \
                -h ${box_name} \
                --name ${box_name} \
                e0d1n/pwnbox

            # Create a workdir for this box
            # Already created by the container
            # docker exec ${box_name} mkdir /root/files

            # Get a shell
            # echo -e "${GREEN}                         ______               ${RESET}"
            # echo -e "${GREEN}___________      ___________  /___________  __${RESET}"
            # echo -e "${GREEN}___  __ \\_ | /| / /_  __ \\_  __ \\  __ \\_  |/_/${RESET}"
            # echo -e "${GREEN}__  /_/ /_ |/ |/ /_  / / /  /_/ / /_/ /_>  <  ${RESET}"
            # echo -e "${GREEN}_  .___/____/|__/ /_/ /_//_.___/\\____//_/|_|  ${RESET}"
            # echo -e "${GREEN}/_/                           by e0d1n  ${RESET}"
            # echo ""
        fi
        docker attach ${box_name}
    fi
}

