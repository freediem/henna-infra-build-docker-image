FROM amazoncorretto:17-alpine3.17-jdk

RUN apk --no-cache update && \
    apk add curl wget zip tar git jq python3 bash yq

#################################################  
# enable TINI (lightweight init)
# url: https://github.com/krallin/tini  
#################################################
ARG TINI_VERSION=v0.19.0
RUN apk --no-cache update && \
    apk add curl ca-certificates openssl && \
    curl -Lo /usr/local/bin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 && \
    chmod +x /usr/local/bin/tini

#################################################  
# install glibc 
# alpine linux use musl for C standard library.
# However most program use glibc, so some incompatibility issue with musl could appear. 
# In this case, we need manual install of glibc.
# url: https://github.com/sgerrand/alpine-pkg-glibc/
#################################################
ARG GLIBC_VERSION=2.34-r0
RUN apk add binutils && \
    curl -k -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
    curl -k -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    curl -k -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    curl -k -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk add --no-cache --force-overwrite \
        glibc-${GLIBC_VERSION}.apk \
        glibc-bin-${GLIBC_VERSION}.apk \
        glibc-i18n-${GLIBC_VERSION}.apk \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8\
    && rm -rf glibc-*.apk

#################################################
# install awscliv2 + remove unnecessary files
#################################################
RUN curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/current/dist/aws_completer \
        /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/current/dist/awscli/examples \
    && find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete \
    && rm -rf /var/cache/apk/*

#################################################
# copy and unzip cubeone install files
#################################################
COPY cubeone.tar /home/cubeone.tar
RUN tar -xf /home/cubeone.tar -C /home