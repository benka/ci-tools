##########################
# call this script from crontab
# sudo crontab -e
# 40 12 * * 1-5 ~/dev/corespring/ci-tools/heroku-dyno-schedule/heroku-scale-dynos.sh upscale-number app-name
# 05 01 * * 2-6 ~/dev/corespring/ci-tools/heroku-dyno-schedule/heroku-scale-dynos.sh downscale-number app-name
##########################

#!/bin/bash
if [ -z $1 ] || [ -z $2 ]; then
  echo Usage:
  echo scale-dynos.sh number-of-dynos app-name
  echo Where:
  echo number-of-dynos is an integer, the target number of the Dynos after scaling
  echo app-name is the Heroku app name:
  echo " "
  echo example:
  echo scale-dynos.sh 4 heroku-test-app
  echo will scal heroku-test-app to 4 dynos
  exit 0
else
  echo Heroku app: $2
  echo Number of Web Dynos: $1
fi

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
LOGFILE=heroku-scale-dynos.log

echo "$(date) - Heroku app: $2 > Dynos: $1" >> $SCRIPT_DIR/$LOGFILE
heroku ps:scale web=$1 -a $2 >> $SCRIPT_DIR/$LOGFILE
echo "----------------------------------------------------------"
