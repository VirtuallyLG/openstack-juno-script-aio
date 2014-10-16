#!/bin/bash -ex 

source config.cfg

echo "########## CAU HINH IP STATIC CHO NICs ##########"

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
cat << EOF > $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# EXT NETWORK
auto eth0
iface eth0 inet static
address $MASTER
netmask 255.255.255.0
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8

# DATA NETWORK
auto eth1
iface eth1 inet static
address $LOCAL_IP
netmask 255.255.255.0

EOF

/etc/init.d/networking restart 

echo "########## Repos of JUNO ##########"


apt-get install python-software-properties -y
add-apt-repository cloud-archive:juno -y 

sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade 

iphost=/etc/hosts
test -f $iphost.orig || cp $iphost $iphost.orig
rm $iphost

echo "########## SETUP HOTSNAME, IP ADDRESS for UBUNUT ##########"

hostname controller
echo "controller" > /etc/hostname

# Mo hinh AIO nen su dung loopback
cat << EOF >> $iphost
127.0.0.1       localhost
127.0.1.1       controller
$eth0_address	controller
$eth1_address	controller
 
# The following lines are desirable for IPv6 capable hosts
# ::1     ip6-localhost ip6-loopback
# fe00::0 ip6-localnet
# ff00::0 ip6-mcastprefix
# ff02::1 ip6-allnodes
# ff02::2 ip6-allrouters
EOF

# Sua file host ko can restart network
# /etc/init.d/networking restart 

# Enable IP forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter=0" >> /etc/sysctl.conf
sysctl -p

echo "########## INSTALL & CONFIG NTP ##########"
sleep 3
apt-get install -y ntp

# Cau hinh NTP trong ICEHOUSE
# sed -i 's/server ntp.ubuntu.com/ \
# server ntp.ubuntu.com \
# server 127.127.1.0 \
# fudge 127.127.1.0 stratum 10/g' /etc/ntp.conf

## Cau hinh NTP trong JUNO
sed -i 's/server ntp.ubuntu.com/ \
server 0.vn.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst \
server 2.asia.pool.ntp.org iburst/g' /etc/ntp.conf

sed -i 's/restrict -4 default kod notrap nomodify nopeer noquery/ \
#restrict -4 default kod notrap nomodify nopeer noquery/g' /etc/ntp.conf

sed -i 's/restrict -6 default kod notrap nomodify nopeer noquery/ \
restrict -4 default kod notrap nomodify \
restrict -6 default kod notrap nomodify/g' /etc/ntp.conf


echo "########## Restart service NTP ##########"
sleep 3
service ntp restart


echo "########## Installing service RABBITMQ ##########"
sleep 3
apt-get -y install rabbitmq-server

echo "########## Set password for RABBITMQ ##########"
# sleep 3
rabbitmqctl change_password guest $RABBIT_PASS
echo "########## Reboot server, bye bye ##########"
sleep 3
service rabbitmq-server restart
sleep 3
init 6 
