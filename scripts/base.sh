#!/bin/sh
set -e

# Don't upgrade kernel, it breaks hgfs module which breaks shared folders for VMware which prevents chef provisioning
#echo "linux hold" | dpkg --set-selections
#echo "linux-headers hold" | dpkg --set-selections

# Edit listchanges 'frontend=text' so it doesn't freeze our non-interactive script when there's an imoportant changelog
cat >/etc/apt/listchanges.conf <<EOL
[apt]
frontend=text
email_address=root
confirm=0
save_seen=/var/lib/apt/listchanges.db
which=news
EOL

# Define Kali as Debian-based so that vmware knows how to configure network devices.  We're keeping it here so that vbox and vmware machines are identical.
# echo "Define kali as Debian-based in /etc/issue"
# sudo dd of=/etc/rc.local << EOF
# #!/bin/sh -e
# #
# # rc.local
# #
# #/usr/bin/custom-issue.sh
# echo "Debian GNU/Linux 7" > /etc/issue
# exit 0
# EOF

# Update
# Needed because this package prevents packer from updating to box
apt-mark hold king-phisher
apt -yq update
#apt-get -y upgrade
export DEBIAN_FRONTEND=noninteractive
apt -yq full-upgrade
# Have to run dist-upgrade with these options to get around the new libssl update that requires user input.
# DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" dist-upgrade

# Install helpful things
#apt-get -y install linux-headers-$(uname -r) build-essential
apt -yq install open-vm-tools-desktop fuse
#apt-get -y install zlib1g-dev libreadline-gplv2-dev curl unzip vim

# Set up sudo (thanks to codeship.io)
# groupadd -r admin
# usermod -a -G admin vagrant
cp /etc/sudoers /etc/sudoers.orig
# sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
# sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
grep -q 'secure_path' /etc/sudoers \
  || sed -i -e '/Defaults\s\+env_reset/a Defaults\tsecure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' /etc/sudoers;

# Set up password-less sudo for the vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;
chmod 440 /etc/sudoers.d/99_vagrant;

apt -y autoremove
apt -y clean

# Auto Login as root
# cat >>/etc/gdm3/daemon.conf <<EOL
# [daemon]
# AutomaticLoginEnable = true
# AutomaticLogin = root
# EOL

# Tweak sshd to prevent DNS resolution (speed up logins)
# echo 'UseDNS no' >> /etc/ssh/sshd_config

# Fix the "network interface device not managed" error that Kali likes so damned much
# echo "Set devices to be managed by NetworkManager"
# cat <<EOF > /etc/NetworkManager/NetworkManager.conf
# [main]
# plugins=ifupdown,keyfile
#
# [ifupdown]
# managed=true
# EOF



# Change permissions to /var/www/ so Packer can transfer some files to it
# chmod 777 /var
# chmod 777 /var/www

# Remove 5s grub timeout to speed up booting
# cat <<EOF > /etc/default/grub
# # If you change this file, run 'update-grub' afterwards to update
# # /boot/grub/grub.cfg.
#
# GRUB_DEFAULT=0
# GRUB_TIMEOUT=0
# GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
# GRUB_CMDLINE_LINUX_DEFAULT="quiet"
# GRUB_CMDLINE_LINUX="debian-installer=en_US"
# EOF
#
# update-grub
