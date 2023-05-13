# debian11 doesn't come with iptables (and I refuse to use nftables)
sudo apt update
sudo apt install iptables

#block all traffic by default
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# enable external access
sudo iptables -A INPUT -i tun0 -p tcp --destination-port 53 -j ACCEPT
sudo iptables -A INPUT -i tun0 -p udp --destination-port 53 -j ACCEPT
sudo iptables -A INPUT -i tun0 -p tcp --destination-port 80 -j ACCEPT

# setup for local access (see https://docs.pi-hole.net/main/prerequisites/)
iptables -I INPUT 1 -s 192.168.0.0/16 -p tcp -m tcp --dport 80 -j ACCEPT
iptables -I INPUT 1 -s 127.0.0.0/8 -p tcp -m tcp --dport 53 -j ACCEPT
iptables -I INPUT 1 -s 127.0.0.0/8 -p udp -m udp --dport 53 -j ACCEPT
iptables -I INPUT 1 -s 192.168.0.0/16 -p tcp -m tcp --dport 53 -j ACCEPT
iptables -I INPUT 1 -s 192.168.0.0/16 -p udp -m udp --dport 53 -j ACCEPT
iptables -I INPUT 1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT
iptables -I INPUT 1 -p tcp -m tcp --dport 4711 -i lo -j ACCEPT
iptables -I INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
