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
# Clone some tools I commonly use
git clone https://github.com/Raikia/CredNinja.git
git clone https://github.com/lgandx/PCredz.git
git clone https://github.com/danielmoore-info/IPCleaner.git
git clone https://github.com/maurosoria/dirsearch.git

# Install routersploit
apt-get -y install python3-pip
git clone https://www.github.com/threat9/routersploit
cd routersploit
python3 -m pip install -r requirements.txt

# Install crackmapexec
apt-get -y install crackmapexec

# Install tool to interact with iscsi
apt-get -y install open-iscsi

# Install NFS client
apt-get -y install nfs-common
