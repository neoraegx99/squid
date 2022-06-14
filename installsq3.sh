### mod by sangmander kasang  thai4g
#sed -i '10d' fileName.tx
#sed -i '1d' /etc/hosts
#sed '/12
sed -i "1i 127.0.0.1   thai4g" /etc/hosts
cp /etc/squid/squid.conf /home/squidx.conf
apt purge squid -y >/dev/null 2>&1
cd /etc
rm -rf squid
cd
echo
touch /etc/apt/sources.list.d/trusty_sources.list
echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty main universe" | sudo tee --append /etc/apt/sources.list.d/trusty_sources.list > /dev/null
apt update
apt install -y squid3=3.3.8-1ubuntu6 squid=3.3.8-1ubuntu6 squid3-common=3.3.8-1ubuntu6
rm -f squid3
wget https://raw.githubusercontent.com/neoraegx99/squid/main/squid3 > /dev/null
rm -f /etc/init.d/squid3
cp squid3 /etc/init.d/
chmod +x /etc/init.d/squid3
update-rc.d squid3 defaults
rm -f squid3
rm -f xip
hostname -I | awk '{print $1}'>xip
MIP=$(cat xip)
IP=$MIP
MYIP=$MIP
SERVER_IP=$MIP
cat > /etc/squid3/squid.conf <<END
http_port 8080
#http_port 1080
acl url2 dstdomain -i thai4g
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst $SERVER_IP-$SERVER_IP/255.255.255.255
acl SSH dst 127.0.0.1-127.0.0.1/255.255.255.255
http_access allow SSH
http_access allow localnet
http_access allow localhost
http_access allow url2
http_access deny all
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
END
service squid3 start
service squid3 stop
service squid3 restart
