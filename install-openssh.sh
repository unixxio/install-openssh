#!/bin/bash

#####################################################
#                                                   #
#  Description : Install OpenSSH server from APT    #
#  Author      : Unixx.io                           #
#  E-mail      : github@unixx.io                    #
#  GitHub      : https://www.github.com/unixxio     #
#  Last Update : November 22, 2021                  #
#                                                   #
#####################################################
clear

# Variables
distro="$(lsb_release -sd | awk '{print tolower ($1)}')"
release="$(lsb_release -sc)"
version="$(lsb_release -sr)"
kernel="$(uname -r)"
uptime="$(uptime -p | cut -d " " -f2-)"
my_username="$(whoami)"
user_ip="$(who am i --ips | awk '{print $5}' | sed 's/[()]//g')"
user_hostname="$(host ${user_ip} | awk '{print $5}' | sed 's/.$//')"

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Show the current logged in user
echo -e "\nHello ${my_username}, you are logged in from ${user_ip} (${user_hostname}).\n"

# Show system information
echo -e "Distribution : ${distro}"
echo -e "Release      : ${release}"
echo -e "Version      : ${version}"
echo -e "Kernel       : ${kernel}"

# Check if OpenSSH is already installed
if [[ $(lsof -i TCP:22) ]]; then
    echo -e "\n[ Error ] OpenSSH is already installed. Nothing to do here ;-)\n"
    exit 1
fi

# Script feedback
echo -e "\nWe are now going to install OpenSSH Server. Please wait...\n"

# Update packages
apt-get update > /dev/null 2>&1 && apt-get upgrade -y > /dev/null 2>&1

# Install OpenSSH server
apt-get install openssh-server -y > /dev/null 2>&1

# Enable and start OpenSSH service
systemctl enable ssh > /dev/null 2>&1
systemctl start ssh > /dev/null 2>&1

# Ask if root login should be allowed
echo -e "Do you want to allow root login with password over SSH?"
echo -e "If you choose no you can still use SSH keys."

echo -e "\n[ Warning ] Logging in directly as root over SSH with a password"
echo -e "can be dangerous and is NOT recommended. Use SSH keys instead.\n"
PS="Allow root login with password? (y/n):"
PS3="$(echo -e "${PS}")"
read -r -p "${PS3} " response
case "${response}" in
    [yY][eE][sS]|[yY])
        # Permit root login
        sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
        systemctl restart ssh
        ;;
    [nN][oO]|[Nn])
        # Do not permit root login
        sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
        echo -e "\nLogging in as root over SSH with a password is now disabled."
        echo -e "Make sure you add your SSH key to /root/.ssh/authorized_keys"
        echo -e "if you still wish to use direct root login over SSH."
        systemctl restart ssh
        ;;
    *)
        echo -e "\n[ Error ] Invalid option ${response}. Abort script."
        ;;
esac

# End script
echo -e "\nOpenSSH Server is successfully installed. Enjoy! ;-)\n"
exit 0
