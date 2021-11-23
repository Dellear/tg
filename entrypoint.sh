#!/bin/bash
set -e

# 启动日志服务
service rsyslog start

if [ -f /config/crontab.list ]; then
  echo -e "存在crontab.list，使用crontab.list添加定时任务"
  crontab /config/crontab.list
  echo -e "当前的定时任务如下：\n"
  crontab -l
else
  echo -e "没有检测到crontab.list文件，暂无定时任务"
fi

service cron restart
service cron status

tail -f /var/log/cron.log

exec "$@"