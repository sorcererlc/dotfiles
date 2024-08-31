package helper

import (
	"dotfiles/log"
	"dotfiles/types"
	"os"
	"os/user"
	"strings"
)

func GetEnvironment() (*types.Environment, error) {
	l := log.NewLog("config.log")

	var err error
	e := types.Environment{}

	e.Cwd, err = os.Getwd()
	if err != nil {
		l.Error("Error reading CWD", err.Error())
		return nil, err
	}

	r, err := parseRelease(l)
	if err != nil {
		return nil, err
	}
	e.OS.Id = r["ID"]
	e.OS.Name = r["NAME"]
	e.OS.PrettyName = r["PRETTY_NAME"]
	e.OS.Version = r["VERSION"]
	e.OS.VersionId = r["VERSION_ID"]

	e.User, err = user.Current()
	if err != nil {
		return nil, err
	}

	return &e, nil
}

func parseRelease(l *log.Log) (map[string]string, error) {
	o := make(map[string]string)

	r, err := os.ReadFile("/etc/os-release")
	if err != nil {
		l.Error("Error reading release file", err.Error())
		return nil, err
	}

	lines := strings.Split(string(r), "\n")

	for _, i := range lines {
		if i == "" {
			break
		}
		v := strings.Split(i, "=")
		o[v[0]] = strings.ReplaceAll(v[1], "\"", "")
	}

	return o, nil
}
