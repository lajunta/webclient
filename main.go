package main

import (
	"io/ioutil"
	"log"
	"os"
	"os/user"
	"path"

	"github.com/zserge/lorca"
)

var (
	configDir  string
	defaultURL = "http://127.0.0.1:8080"
	urlfile    string
)

func init() {
	current, _ := user.Current()
	home := current.HomeDir
	configDir = path.Join(home, ".webclient")
	_, err := os.Open(configDir)
	if os.IsNotExist(err) {
		os.MkdirAll(configDir, 0755)
	}
}

func main() {
	urlfile = path.Join(configDir, "url.txt")
	f, _ := os.OpenFile(urlfile, os.O_RDWR|os.O_CREATE, 0755)
	defer f.Close()
	b, _ := ioutil.ReadFile(urlfile)
	if len(b) == 0 {
		f.WriteString(defaultURL)
	} else {
		b, _ := ioutil.ReadFile(urlfile)
		defaultURL = string(b)
	}
	ui, err := lorca.New(defaultURL, "", 1, 1)
	if err != nil {
		log.Fatal(err)
	}
	defer ui.Close()
	<-ui.Done()
}
