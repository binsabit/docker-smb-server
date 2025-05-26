#!/bin/sh

# Create log directory
mkdir -p /var/log/samba

# Set permissions on shared directory
chown -R smbuser:smbgroup /shared
chmod -R 755 /shared

# Update Samba password if environment variables are set
if [ -n "$SMB_PASSWORD" ]; then
    echo "Updating SMB password..."
    echo -e "$SMB_PASSWORD\n$SMB_PASSWORD" | smbpasswd -a -s smbuser
fi

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisord.conf