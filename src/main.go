package main

import (
	"dotfiles/helper"
	"dotfiles/log"
	"dotfiles/setup"
	"os"
)

func main() {
	l := log.NewStdOutLog()

	env, err := helper.GetEnvironment()
	if err != nil {
		os.Exit(1)
	}

	conf, err := helper.GetConfig(l)
	if err != nil {
		os.Exit(1)
	}

	err = setup.NewLinks(env, conf.Links).MakeLinks()
	if err != nil {
		os.Exit(1)
	}
}
