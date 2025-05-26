FROM alpine:latest

# Install Samba and necessary packages
RUN apk add --no-cache \
    samba \
    samba-common-tools \
    supervisor \
    && rm -rf /var/cache/apk/*

# Create samba user and group
RUN addgroup -g 1000 smbgroup && \
    adduser -D -u 1000 -G smbgroup -s /bin/sh smbuser

# Create shared directory
RUN mkdir -p /shared && \
    chown -R smbuser:smbgroup /shared && \
    chmod -R 755 /shared

# Create Samba configuration
RUN mkdir -p /etc/samba
COPY smb.conf /etc/samba/smb.conf

# Create supervisor configuration
COPY supervisord.conf /etc/supervisord.conf

# Set Samba password for the user (default: password)
RUN echo -e "password\npassword" | smbpasswd -a -s smbuser

# Expose Samba ports
EXPOSE 139 445

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]