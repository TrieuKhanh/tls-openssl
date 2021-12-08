#!/bin/bash

BOLD=$(tput bold)
CLEAR=$(tput sgr0)

echo "remove "
rm -f *.key
rm -f *.csr
rm -f *.crt

echo -e "${BOLD}Generating RSA AES-256 Private Key for Root Certificate Authority${CLEAR}"
#openssl genrsa -aes256 -out Root.CA.key 4096
openssl genrsa 2048 > ca-key.pem

echo -e "${BOLD}Generating Certificate for Root Certificate Authority${CLEAR}"
#openssl req -x509 -new -nodes -key Root.CA.key -sha256 -days 1825 -out Root.CA.pem
openssl req -new -x509 -nodes -days 365000 \
   -key ca-key.pem \
   -out ca-cert.pem

echo -e "${BOLD}Generating RSA Private Key and CSR for server${CLEAR}"
#openssl genrsa -out server.key 4096
openssl req -newkey rsa:2048 -nodes -days 365000 \
   -keyout server-key.pem \
   -out server-req.pem

#echo -e "${BOLD}Generating Certificate Signing Request for Server Certificate${CLEAR}"
#openssl req -new -key server.key -out server.csr

echo -e "${BOLD}Generating Certificate for Server${CLEAR}"
#openssl x509 -req -in server.csr -CA Root.CA.pem -CAkey Root.CA.key -CAcreateserial -out server.crt -days 1825 -sha256 -extfile server.ext
openssl x509 -req -days 365000 -set_serial 01 \
   -in server-req.pem \
   -out server-cert.pem \
   -CA ca-cert.pem \
   -CAkey ca-key.pem

#echo -e "${BOLD}Generating Certificate for Server Certificate using certbot${CLEAR}"
#certbot certonly --csr server.csr --manual #--preferred-challenges dns
#certbot --csr server.csr -d test.example.de --manual --preferred-challenges dns certonly

echo -e "${BOLD}Generating RSA Private Key and CSR for client${CLEAR}"
#openssl genrsa -out client.key 4096
openssl req -newkey rsa:2048 -nodes -days 365000 \
   -keyout client-key.pem \
   -out client-req.pem

#echo -e "${BOLD}Generating Certificate Signing Request for Client Certificate${CLEAR}"
#openssl req -new -key client.key -out client.csr

echo -e "${BOLD}Generating Certificate for Client${CLEAR}"
#openssl x509 -req -in client.csr -CA Root.CA.pem -CAkey Root.CA.key -CAcreateserial -out client.crt -days 1825 -sha256
openssl x509 -req -days 365000 -set_serial 01 \
   -in client-req.pem \
   -out client-cert.pem \
   -CA ca-cert.pem \
   -CAkey ca-key.pem

#echo -e "${BOLD}Generating Certificate for Client Certificate using certbot${CLEAR}"
#certbot certonly --csr client.csr --manual #--preferred-challenges dns
#certbot --csr client.csr --manual --preferred-challenges dns certonly

echo -e "${BOLD}Verify Certificates${CLEAR}"
#openssl verify -verbose server.crt
#openssl verify -verbose client.crt
openssl verify -CAfile ca-cert.pem \
   ca-cert.pem \
   server-cert.pem
   
openssl verify -CAfile ca-cert.pem \
   ca-cert.pem \
   client-cert.pem


echo "Done!"

