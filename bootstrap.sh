#!/usr/bin/env bash

# This file was modeled after the bootstrap file of the rails-dev-box, a vagrant machine
# used for core Rails development.
# See: https://github.com/rails/rails-dev-box/blob/master/bootstrap.sh

# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo adding swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

echo updating package information
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential git libssl-dev libsodium-dev

install Ruby ruby2.5 ruby2.5-dev
update-alternatives --set ruby /usr/bin/ruby2.5 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.5 >/dev/null 2>&1

echo installing current RubyGems
gem update --system -N >/dev/null 2>&1

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

install Git git

# Increase number of inotify watchers to aid in deployment
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo installing project gems
su - vagrant -c 'cd /vagrant && sudo bundle install'

echo "creating bash profile"
touch /home/vagrant/.bash_profile
if ! grep "cd /vagrant" /home/vagrant/.bash_profile
then
  echo "cd /vagrant" >> /home/vagrant/.bash_profile
fi

echo 'all set, rock on!'
