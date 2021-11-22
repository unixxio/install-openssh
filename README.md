# Install OpenSSH Server

This installer should work on any Debian based OS. This also includes Ubuntu. If it detects that OpenSSH is already installed, it will abort installation.

**Install CURL first**
```
apt-get install curl -y
```

### Run the installer with the following command
```
bash <( curl -sSL https://raw.githubusercontent.com/unixxio/install-openssh/main/install-openssh.sh )
```

**Requirements**
* Execute as root

**What does it do**
* Install OpenSSH Server from APT
* Allow or disallow root login with password over SSH

**Important Locations**
* /etc/ssh/sshd_config (General configuration)

**SSH Commands**

SSH status
```
systemctl status ssh
```
Stop SSH
```
systemctl stop ssh
```
Start SSH
```
systemctl start ssh
```
Restart SSH
```
systemctl restart ssh
```
Check OpenSSH version
```
ssh -V
```
### Add your SSH key to root user (can be any user)
```
mkdir -p /root/.ssh/
echo "YOUR SSH KEY" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh
chmod 500 /root/.ssh/authorized_keys
```

**Tested on**
* Debian 10 Buster
* Debian 11 Bullseye

## Support
Feel free to [buy me a beer](https://paypal.me/sonnymeijer)! ;-)

## DISCLAIMER
Use at your own risk and always make sure you have backups!
