#!/bin/bash

if [[ $1 == "window" ]]; then
  go build -ldflags="-H windowsgui -s -w" -o webclient.exe
  upx webclient.exe
fi

go build -ldflags="-s -w" -o webclient
upx webclient