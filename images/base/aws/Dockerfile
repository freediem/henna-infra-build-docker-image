FROM 314667246064.dkr.ecr.ap-northeast-2.amazonaws.com/base/alpine-3-17-3:1.0

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
# RUN aws --version

################################
# Install Terraform
################################
ENV TERRAFORM_VER="1.4.4" 
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VER}/terraform_${TERRAFORM_VER}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VER}_linux_amd64.zip && \
    mv terraform /usr/bin && \
    rm -f terraform_${TERRAFORM_VER}_linux_amd64.zip
# RUN terraform --version 

################################
# Install kubectl
################################
RUN curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.25.7/2023-03-17/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv kubectl /usr/local/bin/
# RUN kubectl version --short --client

################################
# Install helm
################################
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh
# RUN helm version --short
