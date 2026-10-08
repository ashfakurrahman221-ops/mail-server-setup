#!/bin/bash
DOMAIN=$1
ADMIN_EMAIL=$2

echo "Installing Certbot..."
apt install -y certbot

echo "Obtaining SSL certificate for $DOMAIN..."
certbot certonly --standalone -d mail.$DOMAIN --non-interactive --agree-tos -m $ADMIN_EMAIL

echo "Configuring Postfix SSL..."
postconf -e "smtpd_tls_cert_file=/etc/letsencrypt/live/mail.$DOMAIN/fullchain.pem"
postconf -e "smtpd_tls_key_file=/etc/letsencrypt/live/mail.$DOMAIN/privkey.pem"
postconf -e "smtpd_use_tls=yes"
postconf -e "smtpd_tls_session_cache_database = btree:\${data_directory}/smtpd_scache"

echo "Configuring Dovecot SSL..."
sed -i "s|#ssl = yes|ssl = yes|" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s|#ssl_cert = <.*|ssl_cert = </etc/letsencrypt/live/mail.$DOMAIN/fullchain.pem|" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s|#ssl_key = <.*|ssl_key = </etc/letsencrypt/live/mail.$DOMAIN/privkey.pem|" /etc/dovecot/conf.d/10-ssl.conf

systemctl restart postfix
systemctl restart dovecot



