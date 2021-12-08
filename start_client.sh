#!/bin/bash

if [ "$1" == "ca" ];
then
echo "using ca"
openssl s_client -connect 127.0.0.1:44330 -cert client-cert.pem -key client-key.pem -CAfile ca-cert.pem
elif [ "$1" == "cl" ];
then
echo "using se"
openssl s_client -connect 127.0.0.1:44330 -cert client-cert.pem -key client-key.pem -CAfile server-cert.pem
fi

#openssl s_client -connect host:port -key our_private_key.pem -showcerts \
                 -cert our_server-signed_cert.pem
