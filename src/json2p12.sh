#!/bin/bash

#
# Convert a GCP JSON key to p12.
# Given openssl, curl,  and jq installed.
#
# Usage: path to json key is the only argument
#
#  json2p12 some-sa.json
#
#
# Expected Results:
#  some-sa.key, some-sa.cert, and some-sa.p12
#  in the same directory as some-sa.json
#
#


# The "java key file" full path
jkfilename=$1

filedir=""
filename=""
filextension=""



#
# Some minimal file checks.
# Make sure the file exists, and it's got a '.json' extension.
#
if [ -f "${jkfilename}" ]; then
    #filename="${jkfilename%.*}"
    filedir=$(dirname "${jkfilename}")
    filename=$(basename ${jkfilename} .json)
    fileextension="${jkfilename##*.}"
else
    echo "${jkfilename} is not a file";
    exit 1
fi


if [ "json" != $fileextension ]; then
    echo "fileextension is not json";
    exit 2;
fi






echo "jkfilename      ${jkfilename}"
echo "filedir         ${filedir}"
echo "filename        ${filename}"
echo "fileextension   ${fileextension}"





# Pull the 'private_key' out of the json keyfile
jq -r ."private_key" ${jkfilename} > ${filedir}/${filename}.key

# Grab the private_key_id and client_x509_cert_url, we'll need when locating the client cert
private_key_id=$(jq -r '.private_key_id' ${jkfilename})
client_x509_cert_url=$(jq -r '.client_x509_cert_url' ${jkfilename})

# Pull the client cert by private_key_id
curl -s ${client_x509_cert_url} | jq -r .\"${private_key_id}\" > ${filedir}/${filename}.cert

# Export
openssl pkcs12 -export \
	-password pass:notasecret \
	-inkey ${filedir}/${filename}.key \
	-in ${filedir}/${filename}.cert \
	-out ${filedir}/${filename}.p12

