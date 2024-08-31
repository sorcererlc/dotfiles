package helper

import (
	"dotfiles/log"
	"dotfiles/types"
	"os"

	"gopkg.in/yaml.v3"
)

func GetConfig(l *log.Log) (*types.Config, error) {
	l.Info("Loading config file")

	fs, err := os.ReadFile("config.yml")
	if err != nil {
		l.Error("Load config file", err.Error())
		return nil, err
	}

	c := types.Config{}
	err = yaml.Unmarshal(fs, &c)
	if err != nil {
		l.Error("Parse config file", err.Error())
		return nil, err
	}

	return &c, nil
}
