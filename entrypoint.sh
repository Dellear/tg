#!/bin/bash
set -e

# cd /root/AutomationTTnode && git pull

# if [ -f /root/AutomationTTnode/crontab-custom.list ]
# then
#   echo -e "存在crontab-custom.list，使用crontab-custom.list添加定时任务"
#   crontab /root/AutomationTTnode/crontab-custom.list
# elif [ -f /root/AutomationTTnode/crontab.list ]
# then
#   echo -e "存在crontab.list，使用crontab.list添加定时任务"
#   crontab /root/AutomationTTnode/crontab.list
# fi

echo -e "当前的定时任务如下：\n"
# crontab -l
# crond -L /root/crond.log
# touch /root/crond.log

# cd /root/AutomationTTnode

# echo -e "定时任务执行中...\n"
# tail -f /root/crond.log

tail -f /dev/null