#!/bin/bash

src1="$HOME/work/src/github.com/madsportslab/mboard-go"
src2="$HOME/src/madsportslab/mboard-electron"
src3="$HOME/work/src/github.com/madsportslab/mboard-www"
dst1="$HOME/build/mboard"
dir1="$HOME/build/mboard/home/mboard/bin"
dir2="$HOME/build/mboard/home/mboard/bin/electron"
dir3="$HOME/build/mboard/etc/systemd/system"
dir4="$HOME/build/mboard/DEBIAN"
dir5="$HOME/build/mboard/home/mboard/.autostart/config"

log()
{
  echo [$1]
}

init_dir()
{
  build_dir $dir1
  build_dir $dir2
  build_dir $dir3
  build_dir $dir4
  build_dir $dir5
}

build_dir()
{
  if ! [ -d $1 ]; then
    log "Creating directory $1"
    mkdir -p $1
  fi
}

go_deps()
{
  go get "github.com/eknkc/amber"
  go get "github.com/gorilla/websocket"
  go get "github.com/gorilla/mux"
  go get "github.com/mattes/go-sqlite3"
  go get "github.com/skip2/go-qrcode"
}

lerror()
{
  echo Error: $1
  exit
}

if ! [ -d $dst ]; then
  lerror "build directory not found."
  init_dir
fi

# mboard-go staging

if [ -d $src1 ]; then
  log "Downloading mboard-go dependencies"
  go_deps
  log "Compiling mboard-go"
  cd $src1
  pwd
  go build
else
  lerror "mboard-go sources not found."  
fi

# mboard-electron staging

# mboard-www staging

