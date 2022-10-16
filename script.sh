#!/bin/bash
#
#
#Made By Arthur Schieszer For Cyberpatriot Team Neofetch
#
#
#Finds the user's name
echo "Before continuing, please make a file on the Desktop called readmeusers.txt and copy all users listed in the readme to it."
echo "Please Enter the Current User's Name"
read varname
#
#
#
#Installs necesecary programs and updates the system
apt -qq --yes install ufw net-tools gufw clamav neofetch htop libpam-cracklib auditd ranger micro tldr nala
apt -qq --yes update
apt -qq --yes upgrade
apt -qq --yes dist-upgrade
#
#
#
#Enables auditing
auditctl -e 1
#
#
#
#Enables and configures the firewall
ufw enable
ufw default allow outgoing
ufw default deny incoming
#
#
#
#Makes the userlist
awk -F: '($3>=1000) {print $1}' /etc/passwd | sort > /home/$varname/Desktop/userlist.txt
echo root >> /home/$varname/Desktop/userlist.txt
sed -i '/nobody/d' /home/$varname/Desktop/userlist.txt
sed -i "/$varname/d" /home/$varname/Desktop/userlist.txt
sort /home/$varname/Desktop/userlist.txt
#
#
#
#Change user passwords
for i in `less /home/$varname/Desktop/userlist.txt`
do
  echo $i
  passwd -e "$i"
  echo -e "CyberpatriotS@14\nCyberpatriotS@14" | passwd "$i"
  chage -m 3 -M 90 -I 30 -W 7 -d 0 "$i"
  echo "$i's password and password age settings have been changed"
done
#
#
#
#Deletes unwanted users
sort /home/$varname/Desktop/readmeusers.txt
touch /home/$varname/Desktop/usersdel.txt
touch /home/$varname/Desktop/usersdiff.txt
#Uses diff to compare users on the readme to users in the system
diff /home/$varname/Desktop/userlist.txt /home/$varname/Desktop/readmeusers.txt > /home/$varname/Desktop/usersdiff.txt
#Uses awk to read diff output
#Reads all names with a < before them
awk '/^\</ {print $2}' /home/$varname/Desktop/usersdiff.txt > /home/$varname/Desktop/usersdel.txt
#Reads all names with a > before them. They do not belong in the usersdel list, so they will be put into antidiff to be removed later.
awk '/^\>/ {print $2}' /home/$varname/Desktop/usersdiff.txt > /home/$varname/Desktop/antidiff.txt
#Remove users in antidiff from usersdel
for i in `less /home/$varname/Desktop/antidiff.txt`
do
  sed -i "/$i/d" /home/$varname/Desktop/usersdel.txt
done
#Comments out unwanted users
for i in `less /home/$varname/Desktop/usersdel.txt`
do
  sed -i "s/$i/#$i/" /etc/passwd
done
#
#
#
#Disables login as root
sed -i 's|root:x:0:0:root:/root:/bin/bash|root:x:0:0:root:/root:/sbin/nologin|' /etc/passwd
#
#
#
#Disable unwanted admins
<<'###BLOCK-COMMENT'
touch /home/$varname/Desktop/readmeadmin.txt
sort /home/$varname/Desktop/readmeadmin.txt
awk '/sudo/ {print $0}' /etc/group > /home/$varname/Desktop/admins.txt
awk -F: '/sudo/ {print $4}' /etc/group > /home/$varname/Desktop/admins2.txt


diff /home/$varname/Desktop/admins2.txt /home/$varname/Desktop/readmeadmin.txt > /home/$varname/Desktop/adminsdiff.txt
awk '/^\</ {print $2}' /home/$varname/Desktop/adminsdiff.txt > /home/$varname/Desktop/adminsdel.txt
awk '/^\>/ {print $2}' /home/$varname/Desktop/adminsdiff.txt > /home/$varname/Desktop/antiadmindiff.txt
for i in `less /home/$varname/Desktop/antiadmindiff.txt`
do
  sed -i "/$i/d" /home/$varname/Desktop/adminsdel.txt
done
###BLOCK-COMMENT
#
#
#
echo "Check the sudoers file using visudo, check the wheel, admin, and sudo groups too."
echo "alias nano=micro" >> /home/$varname/.bashrc
neofetch
