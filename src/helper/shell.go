package helper

import (
	"dotfiles/log"
	"os"
	"os/exec"
	"strings"
)

type Cmd struct {
	Bin  string
	Args []string
}

func Run(a ...string) error {
	b, a := a[0], a[1:]
	c := Cmd{
		Bin:  b,
		Args: append([]string{}, a...),
	}

	cwd, _ := os.Getwd()

	return executeCommand(c, cwd)
}

func RunStdin(a ...string) ([]byte, error) {
	b, a := a[0], a[1:]

	r, err := exec.Command(b, a...).Output()
	if err != nil {
		return nil, err
	}

	return r, nil
}

func executeCommand(cmd Cmd, dir string) error {
	l := log.NewStdOutLog()

	if os.Getenv("TEST") == "true" || os.Getenv("DEBUG") == "true" {
		l.Debug("Executing " + log.Cyan + cmd.Bin + " " + strings.Join(cmd.Args, " ") + log.Reset)
	}

	if os.Getenv("TEST") == "true" {
		return nil
	}

	c := exec.Command(cmd.Bin, cmd.Args...)
	c.Stdout = os.Stdout
	c.Stdin = os.Stdin
	c.Stderr = os.Stderr
	c.Dir = dir

	err := c.Run()
	if err != nil {
		return err
	}

	return nil
}
