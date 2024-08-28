FROM sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/base-image-java11-builder:2.5.1 as openjdk-11

FROM sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/base-image-java-builder:2.5.0 as openjdk-8

FROM sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/base-image-sles-dev:2.5.0

ARG VERSION
ARG CONTAINER_USER_ID=105770
ARG CONTAINER_USER_NAME=eric-log4shell-hotpatch
ENV VERSION_ENV=${VERSION}

LABEL com.ericsson.product-name="eric-log4shell-hotpatch"

WORKDIR /usr/src/app/

VOLUME /usr/src/share

SHELL ["/bin/bash", "-c"]

# CONTAINER_USER_ID is calculated with this formula
# cntr=eric-log4shell-hotpatch; h=$( sha256sum <<< "${cntr}" | cut -f1 -d ' ' ) ; printf -- '%s : %d\n' "${cntr}" "$( bc -q <<< "scale=0;obase=10;ibase=16;(${h^^}%30D41)+186A0" )"
RUN echo "${CONTAINER_USER_ID}:x:${CONTAINER_USER_ID}:${CONTAINER_USER_ID}:An Identity for ${CONTAINER_USER_NAME}:/nonexistent:/bin/false" >> /etc/passwd \
    && echo "${CONTAINER_USER_ID}:!::0:::::" >> /etc/shadow

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl && mv kubectl /usr/local/bin
RUN mkdir jdk8 && mkdir jdk11

COPY Log4jHotPatch.jar Log4jHotPatch.jar
COPY --from=openjdk-8 /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/jre/lib/amd64/libattach.so jdk8/libattach.so
COPY --from=openjdk-8 /usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/lib/tools.jar jdk8/tools.jar
COPY --from=openjdk-11 /usr/lib64/jvm/java-11-openjdk-11/lib/libattach.so jdk11/libattach.so
COPY persist-hotpatch.sh persist-hotpatch.sh

RUN chown -R ${CONTAINER_USER_ID}:0 /usr/src/app && chmod -R g=u /usr/src/app
USER ${CONTAINER_USER_ID}

CMD ["./persist-hotpatch.sh", "--hotpatch-pods"]
