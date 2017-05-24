#! /bin/sh
###################################
#
#author:Dream
#create date:2016-09-09
#desc:Oracle 11gR2 ASM for linux
#
###################################
#
#partprobe /dev/sdb1
partprobe /dev/sdc1
partprobe /dev/sdd1
partprobe /dev/sde1
partprobe /dev/sdf1
#
#
echo " 
ACTION==\"add\", KERNEL==\"sdc1\", RUN+=\"/bin/raw /dev/raw/raw1 %N\"
ACTION==\"add\", KERNEL==\"sdd1\", RUN+=\"/bin/raw /dev/raw/raw2 %N\"
ACTION==\"add\", KERNEL==\"sde1\", RUN+=\"/bin/raw /dev/raw/raw3 %N\"
ACTION==\"add\", KERNEL==\"sdf1\", RUN+=\"/bin/raw /dev/raw/raw4 %N\"" >> /etc/udev/rules.d/60-raw.rules 
#
#
touch /etc/udev/rules.d/99-asm.rules
echo "
KERNLE==\"raw1\",OWNER=\"grid\",GROUP=\"dba\",MODE=\"0664\"
KERNLE==\"raw2\",OWNER=\"grid\",GROUP=\"dba\",MODE=\"0664\"
KERNLE==\"raw3\",OWNER=\"grid\",GROUP=\"dba\",MODE=\"0664\"
KERNLE==\"raw4\",OWNER=\"grid\",GROUP=\"dba\",MODE=\"0664\"" >> /etc/udev/rules.d/99-asm.rules
start_udev
#
#
#
echo  "-------验证 /etc/udev/rules.d/60-raw.rules--------"
cat /etc/udev/rules.d/60-raw.rules
echo  "-------验证 /etc/udev/rules.d/99-asm.rules--------"
cat /etc/udev/rules.d/99-asm.rules
echo  "------------------验证 /dev/raw-------------------"
ls -l /dev/raw
