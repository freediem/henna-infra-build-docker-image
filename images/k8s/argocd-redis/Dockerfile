FROM node:18.16.0-alpine3.17

ARG SVC_USER=svcadm
ARG SVC_GROUP=svcadm

RUN addgroup -S ${SVC_GROUP} && adduser -S ${SVC_USER} -G ${SVC_GROUP}

USER ${SVC_USER}