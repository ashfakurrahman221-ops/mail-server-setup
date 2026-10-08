#!/bin/bash
DOMAIN=$1

echo "Setting hostname..."
postconf -e "myhostname = mail.$DOMAIN"
postconf -e "mydomain = $DOMAIN"
postconf -e "myorigin = /etc/mailname"
postconf -e "mydestination = localhost, $DOMAIN, mail.$DOMAIN"
postconf -e "relayhost ="
postconf -e "mynetworks = 127.0.0.0/8"
postconf -e "mailbox_size_limit = 0"
postconf -e "recipient_delimiter = +"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "home_mailbox = "

echo "$DOMAIN" > /etc/mailname

systemctl restart postfix



