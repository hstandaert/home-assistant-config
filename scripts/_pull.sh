#!/usr/bin/env bash

source $(dirname "$0")/_shared.sh

# =================================================
# SHOW INFO
# =================================================

printf "\n----------------------\n\n"
printf "PULL DATA FROM SERVER"
printf "\n\n----------------------\n\n"

printf "On branch: ${GREEN}$GITBRANCH${NC}\n"
printf "On branch: ${GREEN}$GITBRANCH${NC}\n"
printf "Connecting: ${GREEN}$CREDENTIALS:$PORT${NC}\n"
printf "Pulling From: ${GREEN}$REMOTE_PATH\n${NC}\n"

# =================================================
# PULL DATA
# =================================================

scp -r -P "$PORT" $CREDENTIALS:$REMOTE_PATH/config . | tee log/pull_$TODAY.log

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
