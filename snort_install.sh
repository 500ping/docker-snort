#! /bin/bash
DAQ_VERSION="2.0.7"
SNORT_VERSION="2.9.19"

# Install dependencies
apt-get update && \
apt-get install -y \
    build-essential \
    vim \
    curl \
    gcc \
    flex \
    bison \
    pkg-config \
    libpcap0.8 \
    libpcap0.8-dev \
    libpcre3 \
    libpcre3-dev \
    libdumbnet1 \
    libdumbnet-dev \
    libdaq2 \
    libdaq-dev \
    zlib1g \
    zlib1g-dev \
    liblzma5 \
    liblzma-dev \
    luajit \
    libluajit-5.1-dev \
    libssl1.1 \
    libssl-dev \
    tcpreplay \
    wget \
    python-setuptools \
    python3-pip \
    python3-dev 

# Pre-Setup Snort
ldconfig

mkdir -p /var/log/snort 
mkdir -p /usr/local/lib/snort_dynamicrules 
mkdir -p /etc/snort 
cp -r snort/rules /etc/snort/rules 
cp -r snort/etc /etc/snort/etc 
touch /etc/snort/rules/white_list.rules /etc/snort/rules/black_list.rules

cd /opt/
# Install DAQ
wget https://www.snort.org/downloads/snort/daq-$DAQ_VERSION.tar.gz \
    && tar xvfz daq-$DAQ_VERSION.tar.gz \
    && cd daq-$DAQ_VERSION \
    && ./configure; make; make install

# Install Snort
wget https://www.snort.org/downloads/snort/snort-$SNORT_VERSION.tar.gz \
    && tar xvfz snort-$SNORT_VERSION.tar.gz \
    && cd snort-$SNORT_VERSION \
    && ./configure; make; make install

# Clean Up
apt-get clean 
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/opt/snort-$SNORT_VERSION.tar.gz /opt/daq-$DAQ_VERSION.tar.gz

# Run Snort In Background
snort -D -A fast -l /tmp -c /etc/snort/etc/snort.conf
