#!/bin/bash
#
# About: Import SSL Easily
# Author: liberodark
# Thanks :
# License: GNU GPLv3

version="0.0.1"

echo "Welcome on YunoHost SSL Import Script $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

domain="domain"

mkdir /etc/yunohost/certs/"$domain"/ae_certs
mv ca.pem ssl.key ssl.cer /etc/yunohost/certs/"$domain"/ae_certs/

cd /etc/yunohost/certs/"$domain"/ || exit

mkdir yunohost_self_signed
mv *.pem *.cnf yunohost_self_signed/

# Make a crt.pem for Windows CA / Certificate
cat ae_certs/ssl.cer ae_certs/ca.pem | tee crt.pem

# Make a crt.pem for Gandhi CA / Certificate
cat ae_certs/ssl.crt ae_certs/intermediate_ca.pem ae_certs/ca.pem | sudo tee crt.pem

# Make a key.pem
openssl rsa -in ae_certs/ssl.key -out key.pem -outform PEM

# Secure files
chown root:metronome crt.pem key.pem
chmod 640 crt.pem key.pem
chown root:root -R ae_certs
chmod 600 -R ae_certs

# Restart service
service nginx reload
