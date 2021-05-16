# usage
## start process
```
$ cd hugo
$ docker-compose up
```
## access
see `http://localhost:1313/`

# create docs
```
$ cd hugo && HUGO_ENV=production hugo -v -d ../docs && cd -
```