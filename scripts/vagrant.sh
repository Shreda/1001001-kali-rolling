# Set up Vagrant.
date > /etc/vagrant_box_build_time

# Vagrant user is already created with the preseed file

# Install vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
curl -Lo /home/vagrant/.ssh/authorized_keys \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

mkdir /tools
cd /tools
git clone https://github.com/Raikia/CredNinja.git
git clone https://github.com/lgandx/PCredz.git
git clone https://github.com/danielmoore-info/IPCleaner.git
git clone https://github.com/maurosoria/dirsearch.git
apt-get install crackmapexec


# Install NFS client
apt-get -y install nfs-common
