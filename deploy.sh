apt-get update
apt-get -y install git puppet

puppet module install puppetlabs-vcsrepo
puppet module install puppetlabs-mysql
