#!/bin/bash

#presets (comment this out to assign it yourself during install)
preset = 'y'
base_domain = "http://nerys.io"
hub_domain = "http://nerys.io/hub"
us_domain = "http://nerys.io/source"
yt_domain = "http://nerys.io/track"
tc_domain = "http://nerys.io/team"
hub_port = "8100"
us_port = "8101"
yt_port = "8111"
tc_port = "8011"
cron_email = "admin@irae.io"

apt-get install mc htop git unzip wget curl -y

echo
echo "====================================================="
echo "                     WELCOME"
echo "====================================================="
echo
echo "Hub"
echo "download https://www.jetbrains.com/hub/download/"
echo "read instraction https://www.jetbrains.com/hub/help/1.0/Installing-Hub-with-Zip-Distribution.html"
echo "install into /usr/jetbrains/youtrack/"
echo "====================================="
echo
echo "YouTrack"
echo "download https://www.jetbrains.com/youtrack/download/get_youtrack.html"
echo "read instraction https://confluence.jetbrains.com/display/YTD65/Installing+YouTrack+with+ZIP+Distribution#InstallingYouTrackwithZIPDistribution-InstallingNewYouTrackServer"
echo "install into /usr/jetbrains/youtrack/"
echo "====================================="
echo
echo "Upsource"
echo "download https://www.jetbrains.com/upsource/download/"
echo "read the first https://www.jetbrains.com/upsource/help/2.0/prerequisites.html"
echo "install into /usr/jetbrains/upsource/"
echo "====================================="
echo
echo "TeamCity"
echo "download https://www.jetbrains.com/teamcity/download/"
echo "read the first https://www.jetbrains.com/teamcity/help/2.0/prerequisites.html"
echo "install into /usr/jetbrains/teamcity/"
echo "====================================="

type="y"
echo "Y - will be installing in the auto mode: download all needs, config nginx and others"
echo -n "Do you want to continue? [Y|n]: "
read type

if [ "$type" == "n" ]; then
  exit 0
fi

if [ "$preset" == "n" ]; then
	echo "==================================="
	echo "In order to continue installing need set a few properties for nginx:"

	echo -n "Base domain url: "
	read base_domain

	echo -n "Hub domain url: "
	read hub_domain
	echo -n "hub port: "
	read hub_port

	echo -n "Youtrack domain url: "
	read yt_domain
	echo -n "Youtrack port: "
	read yt_port

	echo -n "Upsource domain url: "
	read us_domain
	echo -n "Upsource port: "
	read us_port

	echo -n "Teamcity domain url: "
	read tc_domain
	echo -n "Teamcity port: "
	read tc_port

	echo -n "Cron email: "
	read cron_email
fi

print_params() {
	echo "================="
	echo
	echo "Base domain url: $base_domain"
	echo "Hub domain url: $hub_domain"
	echo "hub port: $hub_port"
	echo "Youtrack domain url: $yt_domain"
	echo "Youtrack port: $yt_port"
	echo "Upsource domain url: $us_domain"
	echo "Upsource port: $us_port"
  	echo "Teamcity domain url: $tc_domain"
	echo "Teamcity port: $tc_port"
	echo "Cron email: $cron_email"
	echo
	echo "================="
}

if [ "$base_domain" == "" ] || [ "$hub_domain" == "" ] || [ "$hub_port" == "" ] || [ "$yt_domain" == "" ] || [ "$yt_port" == "" ] || [ "$us_domain" == "" ] || [ "$us_port" == "" ] ||[ "$tc_domain" == "" ] || [ "$tc_port" == "" ]; then
  echo "Some parameters are not right somewhere... lol :D"
  exit 1
fi

echo "Please check data"
echo "================="
echo
echo "Base domain url: $base_domain"
echo "Hub domain url: $hub_domain"
echo "Hub port: $hub_port"
echo "Youtrack domain url: $yt_domain"
echo "Youtrack port: $yt_port"
echo "Upsource domain url: $us_domain"
echo "Upsource port: $us_port"
echo "Teamcity domain url: $tc_domain"
echo "Teamcity port: $tc_port"
echo "Cron email: $cron_email"
echo
echo "================="

echo -n "Do you continue? [Y|n]"
read type

if [ "$type" == "n" ]; then
  exit 0
fi
echo -n "Upsource domain url: "
read us_domain
echo -n "Upsource port: "
read us_port


code=`lsb_release -a | grep Codename | sed 's/[[:space:]]//g' | cut -f2 -d:`

echo
echo "debian codename:"
echo "$code"
echo

mkdir -p /var/tmp
pushd /var/tmp

echo
echo "Installing Java JDK 1.8"
echo

if [ "$code" != "jessie" ]; then
  echo "from oracle site"
  echo
  url=http://download.oracle.com/otn-pub/java/jdk/8u60-b27/
  java_version=jdk-8u60-linux-x64.tar.gz
  
  wget -c -O "$java_version" --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "$url$java_version"
  
  mkdir -p /opt/jdk
  
  tar -zxf $java_version -C /opt/jdk
  
  update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_60/bin/java 100
  update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_60/bin/javac 100
else
  apt-get install java8-jdk -y
fi;

echo
java -version
update-alternatives --display java
javac -version
update-alternatives --display javac
echo



mkdir -p /usr/jetbrains/{youtrack,hub,upsource,teamcity}

wget https://download.jetbrains.com/hub/2017.4/hub-ring-bundle-2017.4.7722.zip -O /usr/jetbrains/hub/arch.zip 

wget https://download.jetbrains.com/charisma/youtrack-2017.3.37517.zip -O /usr/jetbrains/youtrack/arch.zip

wget https://download.jetbrains.com/upsource/upsource-2017.2.2398.zip -O /usr/jetbrains/upsource/arch.zip

pushd /usr/jetbrains/hub
unzip arch.zip
popd

pushd /usr/jetbrains/youtrack
unzip arch.zip
popd

pushd /usr/jetbrains/upsource
unzip arch.zip
mv Upsource/* ../upsource/
chmod +x -R ../upsource/
popd

wget https://download.jetbrains.com/teamcity/TeamCity-2017.1.5.tar.gz
tar -xzf TeamCity-10.0.4.tar.gz
mv TeamCity /usr/jetbrains/teamcity
pushd /usr/jetbrains/teamcity
chown -R teamcity /usr/jetbrains/teamcity
popd

make_initd() {
  
  echo "making init.d for $1"

  rq="hub "
  if [ "$1" == "hub" ]; then
    rq=""
  fi

  cat >/etc/init.d/$1 <<EOF
#! /bin/sh
### BEGIN INIT INFO
# Provides:          $1
# Required-Start:    $rq\$local_fs \$remote_fs \$network \$syslog \$named
# Required-Stop:     $rq\$local_fs \$remote_fs \$network \$syslog \$named
# Default-Start:     2 3 4 5
# Default-Stop:      S 0 1 6
# Short-Description: initscript for $1
# Description:       initscript for $1
### END INIT INFO
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
NAME=$1
SCRIPT=/usr/jetbrains/\$NAME/bin/\$NAME.sh
do_start() {
  \$SCRIPT start soft
}
case "\$1" in
  start)
    do_start
    ;;
  stop|restart|status|run|rerun|help)
    \$SCRIPT \$1 \$2
    ;;
  *)
    echo "Usage: sudo /etc/init.d/$1 {start|stop|restart|status|run|rerun}" >&2
    exit 1
    ;;
esac
exit 0
EOF
  
  chmod +x /etc/init.d/$1
  
  update-rc.d $1 defaults
  if [ "$1" != "hub" ]; then
    update-rc.d $1 disable
  fi
}

make_initd_tc() {
  cat >/etc/init.d/$1 <<EOF
  #!/bin/sh
### BEGIN INIT INFO
# Provides:          TeamCity autostart
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start teamcity daemon at boot time
# Description:       Enable service provided by daemon.
# /etc/init.d/teamcity -  startup script for teamcity
### END INIT INFO
 
 
#  Ensure you enter the  right  user name that  TeamCity will run  under
USER="teamcity"
 
export TEAMCITY_DATA_PATH="/usr/jetbrains/teamcity/.BuildServer"
 
case $1 in 
start)
  start-stop-daemon --start  -c $USER --exec /opt/JetBrains/TeamCity/bin/runAll.sh start
 ;;
stop)
  start-stop-daemon --start -c $USER  --exec  /opt/JetBrains/TeamCity/bin/runAll.sh stop
 ;;
 esac
 
exit 0
EOF
chmod +x /etc/init.d/teamcity
update-rc.d teamcity defaults
mkdir /opt/jetbrains/teamcity/.BuildServer/lib/jdbc
pushd /opt/jetbrains/teamcity/.BuildServer/lib/jdbc
wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar
}


echo
make_initd youtrack

echo
make_initd hub

echo
make_initd upsource

echo
make_initd teamcity

echo
echo "configure nginx"

apt-get install -t $code-backports nginx -y

cat >./default<<EOF
server {
	listen 80;
	listen [::]:80;
	server_name $yt_domain;
	server_tokens off;
	
	location / {
		proxy_set_header X-Forwarded-Host \$http_host; 
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; 
		proxy_set_header X-Forwarded-Proto \$scheme; 
		proxy_http_version 1.1;
	
		proxy_pass http://localhost:$yt_port/;
	}
}
server {
	listen 80;
	listen [::]:80;
	server_name $us_domain;
	server_tokens off;
	
	location / {
		proxy_set_header X-Forwarded-Host \$http_host;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_http_version 1.1;
		
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection "upgrade";
	
		proxy_pass http://localhost:$us_port/;
	}
}
server {
	listen 80;
	listen [::]:80;
	server_name $hub_domain;
	server_tokens off;
	
	location / {
		proxy_set_header X-Forwarded-Host \$http_host;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_http_version 1.1;
	
		proxy_pass http://localhost:$hub_port/;
	}
}
server {
	listen 80;
	listen [::]:80;
	server_name $tc_domain;
	server_tokens off;
	
	location / {
		proxy_set_header X-Forwarded-Host \$http_host;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_http_version 1.1;
	
		proxy_pass http://localhost:$tc_port/;
	}
}
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;
	server_name $base_domain;
	server_tokens off;
	
	location / {
		try_files \$uri \$uri/ =404;
	}
}
EOF

mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.old
cp -f default /etc/nginx/sites-available/default

service nginx restart

mkdir -p /root/crons

cat >/root/crons/jetbrains<<EOF
#!/bin/bash
status=404
while [ \$status -eq 404 ]; do
  echo "wait hub..."
  sleep 60
  status=\`curl -s -o /dev/null -w "%{http_code}" http://$hub_domain/hub\`
  echo "hub status \$status"
done
service youtrack start
service upsource start
service hub start
service teamcity start
exit 0
EOF

chmod +x /root/crons/jetbrains

echo "MAILTO=$cron_email" > /tmp/cron_
echo "" >> /tmp/cron_
echo "@reboot /root/crons/jetbrains" > /tmp/cron_
crontab /tmp/cron_

service upsource stop
service youtrack stop
service hub stop
service teamcity stop

/usr/jetbrains/hub/bin/hub.sh configure --listen-port $hub_port --base-url http://$hub_domain
/usr/jetbrains/youtrack/bin/youtrack.sh configure --listen-port $yt_port --base-url http://$yt_domain
/usr/jetbrains/upsource/bin/upsource.sh configure --listen-port $us_port --base-url http://$us_domain
/usr/jetbrains/teamcity/bin/teamcity.sh configure --listen-port $tc_port --base-url http://$tc_domain

service hub start
service youtrack start
service upsource start
service teamcity start

echo "goto setup"
echo $hub_domain
echo $yt_domain
echo $us_domain
echo $tc_domain
