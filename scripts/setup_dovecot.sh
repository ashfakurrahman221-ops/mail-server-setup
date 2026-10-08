#!/bin/bash
echo "Configuring Dovecot..."

# Enable IMAP & POP3
sed -i 's/#protocols = imap pop3 lmtp/protocols = imap pop3 lmtp/' /etc/dovecot/dovecot.conf

# Mail location
sed -i 's|#mail_location =|mail_location = maildir:~/Maildir|' /etc/dovecot/conf.d/10-mail.conf

# Disable plaintext auth over non-TLS
sed -i 's/#disable_plaintext_auth = yes/disable_plaintext_auth = yes/' /etc/dovecot/conf.d/10-auth.conf

systemctl restart dovecot



