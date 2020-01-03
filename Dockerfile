FROM ubuntu:bionic

ENV AWSCLI_VERSION "1.16.310"
ENV LC_ALL "C.UTF-8"

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends -qy python python-pip groff \
 && pip install setuptools --upgrade \
 && pip install wheel \
 && pip install awscli==${AWSCLI_VERSION} \
 && pip uninstall -y setuptools wheel \
 && apt-get remove --purge -qy python-pip python-pip-whl \
 && apt-get clean \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt

ENTRYPOINT ["/usr/local/bin/aws"]