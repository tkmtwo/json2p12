FROM ubuntu


ARG asciidoctor_version=2.0.12
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_pdf_version=1.5.4
ARG asciidoctor_diagram_version=2.1.0
ARG asciidoctor_epub3_version=1.5.0.alpha.19
ARG asciidoctor_mathematical_version=0.3.5
ARG asciidoctor_revealjs_version=4.1.0
ARG kramdown_asciidoc_version=1.0.1
ARG asciidoctor_bibtex_version=0.8.0


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

