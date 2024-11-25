ARG BUILD_ARCH=amd64
FROM --platform=linux/${BUILD_ARCH} quay.io/centos/centos:stream9 AS builder
RUN dnf install -y tar gzip jq && dnf clean all
RUN ARCH=$(uname -m | sed 's/x86_64/amd64/') && \
    GO_VERSION=$(curl -L -s "https://go.dev/dl/?mode=json" | jq -r '.[0].version') && \
    curl -L "https://go.dev/dl/${GO_VERSION}.linux-${ARCH}.tar.gz" -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
WORKDIR /go/src/kubemacpool
COPY . .

ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o build/_output/bin/manager github.com/k8snetworkplumbingwg/kubemacpool/cmd/manager

# Copy the controller-manager into a thin image
FROM --platform=linux/${TARGETARCH} registry.access.redhat.com/ubi9/ubi-minimal
COPY --from=builder /go/src/kubemacpool/build/_output/bin/manager /
ENTRYPOINT ["/manager"]
