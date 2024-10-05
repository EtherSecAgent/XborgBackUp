#!/bin/bash
#webook_url
WEBHOOK_URL="https://discord.com/api/webhooks/1136447021650296852/qLBPFM8UKrdHzMJX_0lMoITr5WPglLUhvngjGlGoPriSvB65kIHz3UJoCuswjfROXCK4"
# Set the path to your Borg Backup executable
BORG=/usr/bin/borg

# Set the repository URL
REPO="ssh://u358698@u358698.your-storagebox.de:23/./StorageBorg"

# Set the path to the directory you want to back up
BACKUP_DIR="/mnt/storageroot/"

# Set the desired backup name format (using date)
BACKUP_NAME="$(date +%Y_%-m_%-d)_StorageRoot_Whole_Net_Backup"

# Set the path to the password file for the repository
BORG_PASSPHRASE_FILE=~/.borgbackup/password

export BORG_PASSPHRASE=$(cat $BORG_PASSPHRASE_FILE)

# Set any additional Borg Backup options, if needed
BORGOPTS="--progress"

# Set log file path
LOGFILE="/opt/scripts/xborg/xborg.log"

MESSAGE="**Borg Backup has started.** New archive: **$BACKUP_NAME**"
curl -H "Content-Type: application/json" -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL
# Run Borg Backup with the specified options, backup directory and password file,
# and write the output to the log file
echo "running backup" $>> $LOGFILE
$BORG create $BORGOPTS $REPO::$BACKUP_NAME $BACKUP_DIR &>> $LOGFILE
echo "running prune job" $LOGFIlE
$BORG prune --keep-daily=7 --keep-weekly=4 --keep-monthly=3 $REPO


# Send a completion message to the Discord webhook
MESSAGE="**Borg Backup has been completed.** New archive: **$BACKUP_NAME**"
curl -H "Content-Type: application/json" -d "{\"content\": \"$MESSAGE\"}" $WEBHOOK_URL

