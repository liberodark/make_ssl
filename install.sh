#!/bin/bash
#
# About: Create SSL Easily
# Author: liberodark
# Thanks :
# License: GNU GPLv3

version="0.0.2"

echo "Welcome on Make SSL Script $version"

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

name=my_domain_name
country_code=FR
country=France
city=Paris
organisation=My_Company
dns_1=my_website.com
dns_2=my_website.com
dns_3=my_website.com
mail=my@email.com
rsa=4096

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

ssl_no_alt_name(){
openssl req -new -sha256 -nodes -out "$name".csr -newkey rsa:"$rsa" -keyout "$name".key -config <(
cat <<-EOF
[req]
default_bits = "$rsa"
prompt = no
default_md = sha256
distinguished_name = dn

[ dn ]
C="$country_code"
ST="$country"
L="$city"
O="$organisation"
OU="$organisation"
emailAddress="$mail"
CN = "$dns_1"
EOF
)
}

ssl_simple(){
openssl req \
	-newkey rsa:"$rsa" -nodes -keyout "$name".key \
        -out "$name".csr \
        -subj "/C=$country_code/ST=$country/L=$city/O=$organisation/OU=$organisation/emailAddress=$mail/CN=$name.fr"

openssl req \
        -key "$name".key \
        -new -out "$name".csr \
        -subj "/C=$country_code/ST=$country/L=$city/O=$organisation/OU=$organisation/emailAddress=$mail/CN=$name.fr"

}

#==============================================
# MAKE SSL
#==============================================

while true; do
    read -r -p "Do you want make ssl certificat with alt name ?" yn
    case $yn in
        [Yy]* ) ssl_alt_name; break;;
        [Nn]* ) ssl_no_alt_name; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
