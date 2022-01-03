#!/usr/bin/env bash

source $(dirname "$0")/_shared.sh

# =================================================
# SHOWING THE REMINDER & INFO
# =================================================

printf "\n----------------------\n\n"
cat $BASEDIR/remind.txt
printf "\n\n----------------------\n\n"

printf "On branch: ${GREEN}$GITBRANCH${NC}\n"
printf "Deploying: ${GREEN}$_HOST_INDEX${NC}\n"
printf "Connecting: ${GREEN}$CREDENTIALS:$PORT${NC}\n"
printf "Sending To: ${GREEN}$REMOTE_PATH\n${NC}\n"

# =================================================
# DEPLOYING
# =================================================

RSYNC_PARAMS=${2:-''}

# call rsync passing the directores, ignore list and ask to up using ssh
ssh -p "$PORT" $CREDENTIALS "sudo chmod -R 777 $REMOTE_PATH"
cd $BASEDIR/../ && rsync -vrzuh $RSYNC_PARAMS -e 'ssh -p '"$PORT" --files-from=$BASEDIR/directories.txt --exclude-from=$BASEDIR/ignore.txt . $CREDENTIALS:$REMOTE_PATH | tee log/deploy_$TODAY.log
ssh -p "$PORT" $CREDENTIALS "sudo chown -R sc-homeassistant:sc-homeassistant $REMOTE_PATH/*"

# =================================================
# RESTART HOME ASSISTANT
# =================================================

printf "\n${GREEN}\nRestarting Home assistant service...${NC}"
ssh -p "$PORT" $CREDENTIALS "sudo systemctl restart pkgctl-homeassistant.service"

# =================================================
# LOG AND FINISH
# =================================================

# sign the log

echo "" >> log/deploy_$TODAY.log &&
echo "By: $(whoami)" >> log/deploy_$TODAY.log
date >> log/deploy_$TODAY.log
echo "Git Branch Deployed: $GITBRANCH" >> log/deploy_$TODAY.log

# finish message

printf "\n${CYAN}Done. Log file saved at log/deploy_$TODAY.log${NC}\n"
