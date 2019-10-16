#!/bin/bash

cat app.ico | $GOPATH/bin/2goarray IconData main > icon.go
rsrc -ico "app.ico"

if [[ $1 == "windows" ]]; then

echo "--------------------------------------------------------------"
echo "|---------   First make 386 version for windows...  ---------|"
echo "--------------------------------------------------------------"

GOOS=windows GOARCH=386  CC=/usr/bin/i686-w64-mingw32-gcc CXX=/usr/bin/i686-w64-mingw32-g++ CGO_ENABLED=0 go  build -ldflags="-H windowsgui" -o "dist/webclient32.exe"

#upx "dist/webclient32.exe"

# build amd64

rsrc -arch "amd64" -ico "app.ico"
echo "--------------------------------------------------------------"
echo "|--------- Second make amd64 version for windows... ---------|"
echo "--------------------------------------------------------------"

GOOS=windows GOARCH=amd64  CC=/usr/bin/x86_64-w64-mingw32-gcc CXX=/usr/bin/x86_64-w64-mingw32-g++ CGO_ENABLED=0 go  build  -ldflags="-H windowsgui -w -s" -o "dist/webclient64.exe"

#upx "dist/webclient64.exe"
fi

rsrc -arch "amd64" -ico "app.ico"
GOOS=linux GOARCH=amd64 CGO_ENABLED=1  go build -ldflags="-w -s" -o "dist/webclient"
chmod 0755 dist/webclient 
upx dist/webclient
