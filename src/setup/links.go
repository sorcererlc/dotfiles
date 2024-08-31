package setup

import (
	"bufio"
	"dotfiles/helper"
	"dotfiles/log"
	"dotfiles/types"
	"os"
	"regexp"
	"slices"
	"strings"
)

type Links struct {
	Log   *log.Log
	Env   *types.Environment
	Links []*types.Link
}

func NewLinks(e *types.Environment, c []*types.Link) *Links {
	return &Links{
		Log:   log.NewStdOutLog(),
		Env:   e,
		Links: c,
	}
}

func (f *Links) MakeLinks() error {
	owAll, owNone := false, false
	ls := f.parseLinks()

	for _, l := range ls {
		if f.targetExists(l.Target) {
			if owNone {
				continue
			}

			if !owAll {
				f.Log.Warn("Target", l.Target, "already exists.\nOverwrite? y = yes, n = no, a = all, x = none")

				in, _ := bufio.NewReader(os.Stdin).ReadString('\n')
				in = strings.ReplaceAll(in, "\n", "")

				if slices.Contains([]string{"N", "n", ""}, in) {
					continue
				}

				if slices.Contains([]string{"X", "x"}, in) {
					owNone = true
					continue
				}

				if slices.Contains([]string{"A", "a"}, in) {
					owAll = true
				}
			}

			err := f.removeTarget(l.Target, l.Su)
			if err != nil {
				return err
			}
		}

		err := f.makeLink(l.Source, l.Target, l.Su)
		if err != nil {
			return err
		}
	}

	return nil
}

func (f *Links) parseLinks() []*types.Link {
	l := []*types.Link{}
	r, _ := regexp.Compile(".*\\*$")

	for _, i := range f.Links {
		if !r.MatchString(i.Source) {
			l = append(l, &types.Link{
				Source: f.Env.Cwd + "/" + i.Source,
				Target: strings.ReplaceAll(i.Target, "$HOME", f.Env.User.HomeDir),
				Su:     i.Su,
			})
			continue
		}

		dir := strings.ReplaceAll(i.Source, "/*", "")

		d, err := f.listDir(dir)
		if err != nil {
			return nil
		}

		for _, fs := range d {
			fss := strings.Split(fs, "/")

			l = append(l, &types.Link{
				Source: f.Env.Cwd + "/" + dir + "/" + fs,
				Target: strings.ReplaceAll(i.Target+"/"+fss[len(fss)-1], "$HOME", f.Env.User.HomeDir),
				Su:     i.Su,
			})
		}
	}

	return l
}

func (f *Links) targetExists(t string) bool {
	_, err := os.Stat(t)
	return err == nil
}

func (f *Links) makeLink(source, target string, su bool) error {
	args := []string{"ln", "-s", source, target}

	if su {
		args = append([]string{"sudo"}, args...)
	}

	err := helper.Run(args...)
	if err != nil {
		f.Log.Error("Create link", source, target, err.Error())
		return err
	}

	return nil
}

func (f *Links) listDir(d string) ([]string, error) {
	fs := []string{}

	e, err := os.ReadDir(d)
	if err != nil {
		f.Log.Error("List directory", err.Error())
		return nil, err
	}

	for _, i := range e {
		fs = append(fs, i.Name())
	}

	return fs, nil
}

func (f *Links) removeTarget(t string, su bool) error {
	args := []string{"rm", "-rf", t}

	if su {
		args = append([]string{"sudo"}, args...)
	}

	err := helper.Run(args...)
	if err != nil {
		f.Log.Error("Remove target", t, err.Error())
		return err
	}

	return nil
}
