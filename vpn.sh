#!/bin/bash
#
#  Création d'un client OpenVPN par C.B pour infowiki.fr
#  Attention, le script doit être lancé en root !
#
echo "Attention, le script doit être lancé en root !"
echo -n "Tapez le nom du client OpenVPN : "
read reponse

cd /etc/openvpn/easy-rsa

echo "Creation du client OpenVPN: $REPONSE"

source vars
./build-key $REPONSE

sudo mkdir /etc/openvpn/clientconf/$REPONSE
sudo cp /etc/openvpn/ca.crt /etc/openvpn/ta.key keys/$REPONSE.crt keys/$REPONSE.key /etc/openvpn/clientconf/$REPONSE

cd /etc/openvpn/clientconf/$REPONSE

cat >> client.conf << EOF
client
dev tun
proto tcp-client
cipher AES-256-CBC
resolv-retry infinite
ca ca.crt
remote `wget -qO- ifconfig.me/ip` 443
cert $REPONSE.crt
key $REPONSE.key
tls-auth ta.key 1
nobind
persist-key
persist-tun
comp-lzo
verb 3
EOF

sudo cp client.conf client.ovpn

sudo zip $REPONSE.zip *.*

echo "Terminé !"
