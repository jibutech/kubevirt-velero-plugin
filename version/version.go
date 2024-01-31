package version

import (
	"fmt"
	"runtime"
	"strings"
)

var (
	gitVersion   = ""
	gitCommit    = ""
	gitTreeState = ""
	buildDate    = ""
)

type info struct {
	Version      string `json:"version"`
	GitVersion   string `json:"gitVersion"`
	GitCommit    string `json:"gitCommit"`
	GitTreeState string `json:"gitTreeState"`
	BuildDate    string `json:"buildDate"`
	GoVersion    string `json:"goVersion"`
	Compiler     string `json:"compiler"`
	Platform     string `json:"platform"`
}

func Get() info {
	return info{
		Version:      strings.SplitN(gitVersion, "-", 2)[0],
		GitVersion:   gitVersion,
		GitCommit:    gitCommit,
		GitTreeState: gitTreeState,
		BuildDate:    buildDate,
		GoVersion:    runtime.Version(),
		Compiler:     runtime.Compiler,
		Platform:     fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH),
	}
}
