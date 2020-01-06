#!/bin/bash
#
# About: Create SSL Easily
# Author: liberodark
# Thanks : *
# License: GNU GPLv3

version="0.0.1"

echo "Welcome on NRPE Install Script $version"

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

distribution=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')

name=my_domain_name
country_code=FR
country=France
city=Paris
organisation=My_Company
dns_1=my_website.com
dns_2=my_website.com
dns_3=my_website.com
mail=my@email.com
rsa=2048

ssl_alt_name(){
openssl req -new -sha256 -nodes -out \*."$name".csr -newkey rsa:"$rsa" -keyout \*."$name".key -config <(
cat <<-EOF
[req]
default_bits = "$rsa"
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C="$country_code"
ST="$country"
L="$city"
O="$organisation"
OU="$organisation"
emailAddress="$mail"
CN = "$dns_1"

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = "$dns_1"
DNS.2 = "$dns_2"
DNS.3 = "$dns_3"
EOF
)
      }
