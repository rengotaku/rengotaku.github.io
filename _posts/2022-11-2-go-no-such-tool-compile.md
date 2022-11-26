# Problem
```
$ go run main.go 
go: no such tool "compile"
```

```
$ go env
GO111MODULE=""
GOARCH="amd64"
GOBIN=""
GOCACHE="/Users/hoge/Library/Caches/go-build"
GOENV="/Users/hoge/Library/Application Support/go/env"
GOEXE=""
GOEXPERIMENT=""
GOFLAGS=""
GOHOSTARCH="amd64"
GOHOSTOS="darwin"
GOINSECURE=""
GOMODCACHE="/Users/hoge/go/pkg/mod"
GONOPROXY=""
GONOSUMDB=""
GOOS="darwin"
GOPATH="/Users/hoge/go"
GOPRIVATE=""
GOPROXY="https://proxy.golang.org,direct"
GOROOT="/usr/local/go"
GOSUMDB="sum.golang.org"
GOTMPDIR=""
GOTOOLDIR="/usr/local/go/pkg/tool/darwin_amd64"
GOVCS=""
GOVERSION="go1.19.2"
GCCGO="gccgo"
GOAMD64="v1"
AR="ar"
CC="clang"
CXX="clang++"
CGO_ENABLED="1"
GOMOD=""
GOWORK=""
CGO_CFLAGS="-g -O2"
CGO_CPPFLAGS=""
CGO_CXXFLAGS="-g -O2"
CGO_FFLAGS="-g -O2"
CGO_LDFLAGS="-g -O2"
PKG_CONFIG="pkg-config"
GOGCCFLAGS="-fPIC -arch x86_64 -m64 -pthread -fno-caret-diagnostics -Qunused-arguments -fmessage-length=0 -fdebug-prefix-map=/var/folders/wr/4vl3089d22z3xktqr5pmg4m80000gp/T/go-build4046623101=/tmp/go-build -gno-record-gcc-switches -fno-common"
```

# Solution
```
export GOROOT="/usr/local/opt/go/libexec"
```
And you should wirte ahead in `.profile`, and so on.

# References
* [All of a sudden go tool: no such tool "compile" - Stack Overflow](https://stackoverflow.com/questions/51182422/all-of-a-sudden-go-tool-no-such-tool-compile)