# Build Stage
FROM vcsomor/alpine-golang-buildimage:1.21.7 AS build-stage

LABEL app="build-go-project-template"
LABEL REPO="https://github.com/vcsomor/go-project-template"

ENV PROJPATH=/go/src/github.com/vcsomor/go-project-template

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/vcsomor/go-project-template
WORKDIR /go/src/github.com/vcsomor/go-project-template

RUN make build-alpine

# Final Stage
FROM lacion/alpine-base-image:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/vcsomor/go-project-template"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/go-project-template/bin

WORKDIR /opt/go-project-template/bin

COPY --from=build-stage /go/src/github.com/vcsomor/go-project-template/bin/go-project-template /opt/go-project-template/bin/
RUN chmod +x /opt/go-project-template/bin/go-project-template

# Create appuser
RUN adduser -D -g '' go-project-template
USER go-project-template

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/go-project-template/bin/go-project-template"]
