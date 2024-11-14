# syntax=docker/dockerfile:1
# check=error=true;skip=InvalidDefaultArgInFrom

ARG MINDTHEGAP_VERSION
ARG KIND_NODE_TAG
FROM ghcr.io/mesosphere/mindthegap:${MINDTHEGAP_VERSION} AS mindthegap

RUN --mount=type=bind,src=mindthegap-images.txt,target=/tmp/mindthegap-images.txt \
    ["/ko-app/mindthegap", \
     "create", "bundle", \
     "--images-file=/tmp/mindthegap-images.txt", \
     "--output-file=/tmp/mindthegap-image-bundle.tar"]

FROM ghcr.io/mesosphere/kind-node:${KIND_NODE_TAG}

RUN --mount=type=bind,from=mindthegap,src=/ko-app/mindthegap,target=/usr/local/bin/mindthegap \
    --mount=type=bind,from=mindthegap,src=/tmp/mindthegap-image-bundle.tar,target=/tmp/mindthegap-image-bundle.tar \
    bash -ec 'nohup containerd & &>/dev/null && /usr/local/bin/mindthegap import image-bundle --image-bundle /tmp/mindthegap-image-bundle.tar'
