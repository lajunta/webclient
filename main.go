package main

import (
	"io/ioutil"
	"log"
	"os"
	"os/user"
	"path"
	"path/filepath"
	"strings"

	"github.com/BurntSushi/toml"
	"github.com/zserge/lorca"
)

// Config is struct for configuration
type Config struct {
	URL    string
	Width  int
	Height int
}

var (
	configDir  string
	defaultURL = "http://www.qq.com"
	configPath string
	configFile string
)

func init() {
	current, _ := user.Current()
	home := current.HomeDir
	configDir = path.Join(home, ".webclient")
	_, err := os.Open(configDir)
	if os.IsNotExist(err) {
		os.MkdirAll(configDir, 0755)
	}
	fname := filepath.Base(os.Args[0])
	fext := filepath.Ext(fname)
	configFile = strings.TrimSuffix(fname, fext) + ".toml"
}

func main() {
	configPath = path.Join(configDir, configFile)
	f, _ := os.OpenFile(configPath, os.O_RDWR|os.O_CREATE, 0755)
	defer f.Close()
	b, _ := ioutil.ReadFile(configFile)
	c := Config{}
	if len(b) == 0 {
		c = Config{URL: defaultURL, Width: 1280, Height: 720}
		toml.NewEncoder(f).Encode(c)
	} else {
		_, err := toml.DecodeFile(configPath, &c)
		if err != nil {
			log.Fatal(err.Error())
		}
	}
	ui, err := lorca.New(c.URL, "", c.Width, c.Height)
	if err != nil {
		log.Fatal(err)
	}
	defer ui.Close()
	<-ui.Done()
}
