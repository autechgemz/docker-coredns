#!/bin/sh
export GOPATH
exec $GOPATH/bin/coredns -conf $GOPATH/etc/Corefile
