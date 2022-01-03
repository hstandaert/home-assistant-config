#!/usr/bin/env bash

source $(dirname "$0")/_hosts.sh

export NC="\e[0m"             # "no colour"
export BLACK="\e[0;30m"       # black
export RED="\e[0;31m"         # red
export GREEN="\e[0;32m"       # green
export YELLOW="\e[38;5;226m"  # yellow 256
export BLUE="\e[0;34m"        # blue
export PURPLE="\e[0;35m"      # purple
export CYAN="\e[0;36m"        # cyan
export GREY="\e[0;37m"        # light grey
export WHITE="\e[1;37m"       # white
export LTRED="\e[1;31m"       # light red
export LTGREEN="\e[1;32m"     # light green
export ORANGE="\e[38;5;208m"  # orange 256

# =================================================
# COLLECTING PARAMS
# =================================================

# $1 = a name referencing an array on _hosts.sh
# $2 = rsync params if you wish to override defaults
# get the _hosts.sh array and split into separated Vars

_HOST_INDEX=${1:-'default'}

eval "CONN=\"\${$_HOST_INDEX[0]}\""
eval "PATH=\"\${$_HOST_INDEX[1]}\""
eval "URL=\"\${$_HOST_INDEX[2]}\""

# CONN is the connection string on _hosts. It will be splited
# into a ssh connection string and a port (if passed port)

CREDENTIALS=${CONN%:*}

if [[ $CONN == *":"* ]]; then
  PORT=${CONN##*:}
else
	PORT=22
fi

# will fail if the passed host reference ($1) wasnt found on _hosts.sh

if [ -z $CREDENTIALS ];then
	printf "\n${RED}ERROR: HOST NOT FOUND ON _HOSTS:${NC}\nHost '$_HOST_INDEX' cound not be found on _hosts.sh file\n\n"
	exit
fi

# get this script abs path and git branch name

BASEDIR=$( cd "$(dirname "$0")" ; pwd -P )
GITBRANCH=$(git branch | grep \* | cut -d ' ' -f2)

# cria a pasta de logs caso nao exista

mkdir -p log

# generates a data timestamp string

TODAY=`date '+%Y_%m_%d__%H_%M_%S'`;

# =================================================
# SHOWING THE REMINDER & INFO
# =================================================

printf "\n----------------------\n\n"
cat $BASEDIR/remind.txt
printf "\n\n----------------------\n\n"

printf "On branch: ${GREEN}$GITBRANCH${NC}\n"
printf "Pulling: ${GREEN}$_HOST_INDEX${NC}\n"
printf "Connecting: ${GREEN}$CREDENTIALS:$PORT${NC}\n"
printf "Path: ${GREEN}$PATH\n${NC}\n"

# =================================================
# DEPLOYING
# =================================================

RSYNC_PARAMS=${2:-''}

scp -P "$PORT" $CREDENTIALS:$PATH/config .

# =================================================
# LOG AND FINISH
# =================================================

# sign the log

echo "" >> log/pull_$TODAY.log &&
echo "By: $(whoami)" >> log/pull_$TODAY.log
date >> log/pull_$TODAY.log
echo "Git Branch Deployed: $GITBRANCH" >> log/pull_$TODAY.log

# finish message

printf "\n${CYAN}Done. Log file saved at log/pull_$TODAY.log${NC}\n"
