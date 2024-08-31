package types

import "os/user"

type Environment struct {
	OS   OS
	Cwd  string
	User *user.User
}

type OS struct {
	Id         string `json:"id"`
	Name       string `json:"name"`
	PrettyName string `json:"pretty_name"`
	Version    string `json:"version"`
	VersionId  string `json:"version_id"`
}

type Link struct {
	Source string `yaml:"source"`
	Target string `yaml:"target"`
	Su     bool   `yaml:"su"`
}

type Config struct {
	Links []*Link `yaml:"links"`
}
