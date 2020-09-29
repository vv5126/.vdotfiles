#!/bin/sh

export GOOS=linux GOARCH=amd64 GO386=sse2 CGO_ENABLED=0
# go build -o a test.go
go build -ldflags "-X main.Version="v3.6.2" -s -w" -o "/backup/home/wgao/.local/bin/bai"
