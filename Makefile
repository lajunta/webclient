.DEFAULT_GOAL := linux
rsrc:
	cat icons/app.ico | ${GOPATH}/bin/2goarray IconData main > icon.go
	rsrc -ico "icons/app.ico"
linux: rsrc
	rsrc -arch "amd64" -ico "icons/app.ico"
	GOOS=linux GOARCH=amd64 CGO_ENABLED=1  go build -ldflags="-w -s" -o "dist/webclient"
	chmod 0755 dist/webclient 
	upx dist/webclient

windows: rsrc
	GOOS=windows GOARCH=386  CC=/usr/bin/i686-w64-mingw32-gcc CXX=/usr/bin/i686-w64-mingw32-g++ CGO_ENABLED=0 go  build -ldflags="-H windowsgui" -o "dist/webclient32.exe"
	upx "dist/webclient32.exe"
	rsrc -arch "amd64" -ico "icons/app.ico"
	GOOS=windows GOARCH=amd64  CC=/usr/bin/x86_64-w64-mingw32-gcc CXX=/usr/bin/x86_64-w64-mingw32-g++ CGO_ENABLED=0 go  build  -ldflags="-H windowsgui -w -s" -o "dist/webclient64.exe"
	upx "dist/webclient64.exe"
