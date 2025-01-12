#!/bin/bash
	
apt update
apt install vsftpd -y
	
systemctl start vsftpd
systemctl enable vsftpd
	
echo "vsftpd started..."
	
ufw allow ftp
ufw allow 20/tcp
ufw allow 21/tcp
	
echo "done."
	
# Ftp setting script from scale7788 vps i just fix sh1t and added my custom settings.
# enjoy!
# Leak by w_sh1t
