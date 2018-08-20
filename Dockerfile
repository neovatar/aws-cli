FROM ubuntu:bionic-20180724.1

ENV AWSCLI_VERSION "1.15.81"

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends -qy python python-pip \
 && pip install setuptools --upgrade \
 && pip install wheel \
 && pip install awscli==${AWSCLI_VERSION} \
 && pip uninstall -y setuptools wheel \
 && apt-get remove --purge -qy python-pip python-pip-whl \
 && apt-get clean \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt

ENTRYPOINT ["/usr/local/bin/aws"]