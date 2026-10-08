#!/bin/bash
# Mail server installer for Ubuntu 18.04

set -e

DOMAIN=$1
ADMIN_EMAIL=$2

if [ -z "$DOMAIN" ] || [ -z "$ADMIN_EMAIL" ]; then
  echo "Usage: sudo bash install.sh <domain> <admin_email>"
  exit 1
fi

echo "Updating system..."
apt update && apt upgrade -y

echo "Installing required packages..."
apt install -y postfix dovecot-core dovecot-imapd dovecot-pop3d ufw certbot mailutils

echo "Configuring Postfix..."
bash scripts/setup_postfix.sh "$DOMAIN"

echo "Configuring Dovecot..."
bash scripts/setup_dovecot.sh

echo "Setting up SSL certificates..."
bash scripts/setup_ssl.sh "$DOMAIN" "$ADMIN_EMAIL"

echo "Configuring firewall..."
ufw allow 22
ufw allow 25
ufw allow 587
ufw allow 993
ufw --force enable

echo "Restarting services..."
systemctl restart postfix
systemctl restart dovecot

echo "Mail server setup is complete!"
echo "You can check mail logs with: tail -f /var/log/mail.log"



