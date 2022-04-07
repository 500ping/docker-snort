export DEBIAN_FRONTEND=noninteractive
apt-get -yq install snort
snort -D -A fast -l /tmp -c /etc/snort/snort.conf