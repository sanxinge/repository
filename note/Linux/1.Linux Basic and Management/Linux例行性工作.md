# Linux例行性工作
例行性作业/工作说的是在指定时间点自动作业，也理解为调度或定时任务。可以是一次性也可以是周期性作业。
## 一、一次性的例行性工作
1. at和atd
at：是个仅执行一次就结束的调度命令，不过要执行at时，必须要有atd这个守护进程的支持才行。
2. 操作
启动守护进程：
[root@www ~]#server atd status
[root@www ~]#systemctl status atd
开机自启:
[root@www ~]#chkconfig atd on
[root@www ~]#systemctl enable atd

## 二、周期性的例行性工作
相对于 at 是仅执行一次的工作，循环执行的例行性工作调度则是由 cron (crond) 这个系统服务来控制的。Linux提供用户控制例行性工作调度的命令：crontab。
1. crond的配置
+ 在/etc/crontab文件里存放有系统运行的一些调度程序(centos 7.2在/etc/cron.d/0hourly里)
+ /etc/cron.deny 和 /etc/cron.allow 文件
+ /etc/cron.deny 表示不能使用crontab 命令的用户
+ /etc/cron.allow 表示能使用crontab的用户。
+ 如果两个文件同时存在，那么/etc/cron.allow 优先。
+ 如果两个文件都不存在，那么只有超级用户可以安排作业。
+ 每个用户都会生成一个自己的crontab 文件。这些文件在/var/spool/cron目录下。
2. 语法
[root@www ~]# crontab [-u user] [ -e | -l | -r ]
参数：
-e ：编辑crontab的工作内容
-u：只有root才能进行这个任务，也即帮助其他用户新建立/删除crontab工作调度
-l：查阅crontab的工作内容
-r：删除所有的crontab的工作内容，若仅要删除一项，请用-e去删除
3. 内容

4. 多个命令可以放在一行上，其执行情况得依赖于用在命令之间的分隔符。
+ 如果每个命令被一个分号 (;) 所分隔，那么命令会连续的执行下去
+ 如果每个命令被 && 号分隔，那么这些命令会一直执行下去，如果中间有错误的命令存在，则不再执行后面的命令，没错则执行到完为止
+ 如果每个命令被双竖线(||)分隔符分隔，如果命令遇到可以成功执行的命令，那么命令停止执行，即使后面还有正确的命令则后面的所有命令都将得不到执行。假如命令一开始就执行失败，那么就会执行 || 后的下一个命令，直到遇到有可以成功执行的命令为止，假如所有的都失败，则所有这些失败的命令都会被尝试执行一次。
+ 如：
0 04 * * * yum update -y > ~/123.txt;date >> ~/123.txt
