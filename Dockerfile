FROM ubuntu



# Installing package required for the runtime of
# any of the asciidoctor-* functionnalities
RUN apt-get clean && apt-get update
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install openssl
RUN apt-get -y install jq


ADD src/json2p12.sh /usr/local/bin/json2p12
RUN chmod 755 /usr/local/bin/json2p12

WORKDIR /keyfiles
VOLUME /keyfiles


CMD ["/bin/bash"]

