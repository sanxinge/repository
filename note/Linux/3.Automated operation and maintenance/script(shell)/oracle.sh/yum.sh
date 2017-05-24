#! /bin/bash
#
#
#local yum configuring
#####################################
function create()
{
mkdir -p /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
read -p "repos files path:" path1
echo -n "[Media]
name=Media
baseurl=file:///media/cdrom/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/Media.repo
mkdir -p "$path1"
}
#
while [ "$choose" != 1 -a "$choose" != 2 -a "$choose" != "n" -a "$choose" != "N" ]
do
      echo 'Whether or not tobuild local YUM entrepot:'
      read -p "1:mount cdrom  2:local files  n:no  [1/2/n]" choose
done
case "$choose" in
	    1)
		create
		mount /dev/cdrom "$path1"
		yum clean all
		yum list
		;;
	    2)
		create
		yum clean all
		yum list
		;;
	 [Nn])
        	echo '------Network source access point.---------';;
esac

