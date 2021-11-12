
FROM 192.168.130.202:60080/3rdparty/golang:1.13 as builder

RUN mkdir -p /go/src/repo-demo

WORKDIR /go/src/repo-demo

COPY . /go/src/repo-demo

RUN GO111MODULE=off CGO_ENABLED=0 GOOS=linux GOARCH=amd64  go build  -a -installsuffix cgo -o repo-demo.bin /go/src/repo-demo/

FROM 192.168.130.202:60080/3rdparty/alpine:3.13

WORKDIR /go

COPY --from=builder /go/src/repo-demo/repo-demo.bin ./

RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

ENTRYPOINT ["/go/repo-demo.bin"]
