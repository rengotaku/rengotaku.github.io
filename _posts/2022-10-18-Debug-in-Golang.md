# Problem
Although I used debug feature in VS Code following this article [debugging · golang/vscode-go Wiki](https://github.com/golang/vscode-go/wiki/debugging#getting-started), I got the error as below:

`Failed to launch: could not launch process: can not run under Rosetta, check that the installed build of Go is right for your CPU architecture`

Not sure, but Go version I used was `go1.18 darwin/amd64` and wasn't correct for using `dlv`. 
I used the `Apple M1` chip laptop.

# How
Reinstall Go.

## Uninstalling Go
```
sudo rm -rf /usr/local/go
```

## Install Go of arm64
```
[1] Download and install the ARM64 installer package from https://golang.org - https://go.dev/dl/go1.18.darwin-arm64.pkg
[2] Run go install github.com/go-delve/delve/cmd/dlv@latest from the command-line.
[3] Run go install github.com/aarzilli/gdlv@latest from the command line.
```

## Changing PATH
I changed `GOROOT` env from `/usr/local/opt/go/libexec` which was set up from brew.

`cat $HOME/.profile`
```
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
```

# References
* [Managing Go installations - The Go Programming Language](https://go.dev/doc/manage-install#uninstalling)
* [dlv debug return error on mac m1 · Issue #2604 · go-delve/delve](https://github.com/go-delve/delve/issues/2604#issuecomment-1069740132)
