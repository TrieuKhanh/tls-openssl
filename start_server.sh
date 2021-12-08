#!/bin/bash

if [ "$1" == "ca" ];
then
echo "using ca"
openssl s_server -key server-key.pem -cert server-cert.pem -accept 44330 -Verify 0 \
   -CAfile ca-cert.pem
elif [ "$1" == "cl" ];
then
echo "using cl"
openssl s_server -key server-key.pem -cert server-cert.pem -accept 44330 -Verify 0 \
   -CAfile client-cert.pem
fi
