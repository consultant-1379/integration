ARG GO_IMAGE_VERSION="2.7.2"
FROM sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/base-image-golang-builder:${GO_IMAGE_VERSION} as init-builder
WORKDIR /usr/src/app
RUN mkdir go
ENV GOPATH=/usr/src/app/go
COPY render_template.go .
COPY go.mod .
COPY go.sum .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o render_template .

FROM sekidocker.rnd.ki.sw.ericsson.se/proj-renegade/base-image-sles-dev:2.5.0
ARG CONTAINER_USER_ID=106678

WORKDIR /usr/src/app

SHELL ["/bin/bash", "-c"]

# CONTAINER_USER_ID is calculated with this formula
# cntr=eric-log4shell-hotpatch; h=$( sha256sum <<< "${cntr}" | cut -f1 -d ' ' ) ; printf -- '%s : %d\n' "${cntr}" "$( bc -q <<< "scale=0;obase=10;ibase=16;(${h^^}%30D41)+186A0" )"
RUN echo "${CONTAINER_USER_ID}:x:${CONTAINER_USER_ID}:${CONTAINER_USER_ID}:An Identity for ${CONTAINER_USER_NAME}:/nonexistent:/bin/false" >> /etc/passwd \
    && echo "${CONTAINER_USER_ID}:!::0:::::" >> /etc/shadow

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl && mv kubectl /usr/local/bin

COPY --from=init-builder /usr/src/app/render_template .
COPY patch-volume.tmpl .
COPY patch-volume.sh .

RUN chmod +x /usr/src/app/render_template && chmod +x /usr/src/app/patch-volume.sh
RUN chown -R ${CONTAINER_USER_ID}:0 /usr/src/app && chmod -R g=u /usr/src/app

USER ${CONTAINER_USER_ID}

CMD ["/usr/src/app/patch-volume.sh", "--patch-volumes", "--patch-env-var" ]
