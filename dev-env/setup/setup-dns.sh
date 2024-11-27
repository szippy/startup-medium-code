# fix DNS
mkdir -pv $(brew --prefix)/etc/
echo 'address=/cd.argoproj.io/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
echo 'address=/.localhost/127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf

brew services start dnsmasq
brew services restart dnsmasq

mkdir -v /etc/resolver
bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/localhost'
bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/cd.argoproj.io'
