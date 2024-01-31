FROM --platform=$BUILDPLATFORM golang:1.21-bookworm AS build

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
ARG GOPROXY

ENV GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT} \
    GOPROXY=${GOPROXY}

COPY . /go/src/kubevirt-velero-plugin
WORKDIR /go/src/kubevirt-velero-plugin
RUN export GOARM=$( echo "${GOARM}" | cut -c2-) && \
    CGO_ENABLED=0 go build -v -o /go/bin/kubevirt-velero-plugin . && \
    CGO_ENABLED=0 go build -v -o /go/bin/cp-plugin ./hack/cp-plugin

FROM scratch
COPY --from=build /go/bin/kubevirt-velero-plugin /plugins/
COPY --from=build /go/bin/cp-plugin /bin/cp-plugin
USER 65532:65532
ENTRYPOINT ["/bin/cp-plugin", "/plugins/kubevirt-velero-plugin", "/target/kubevirt-velero-plugin"]