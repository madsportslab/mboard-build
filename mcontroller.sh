#!/bin/bash

src1="$HOME/work/src/github.com/madsportslab/mcontroller"
src2="$src1/debian/etc/systemd/system"
src3="$HOME/assets"
dst1="$HOME/build/mcontroller"
dir1="$dst1/home/madsportslab/bin"
dir2="$dst1/etc/systemd/system"
dir3="$dst1/DEBIAN"

log()
{
  echo [$1]
}

clean()
{
  if [ -d $dst1 ]; then
    cd $dst1
    rm -rf *
  fi
}

init_dir()
{
  build_dir $dir1
  build_dir $dir2
  build_dir $dir3
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
  go get "github.com/gorilla/mux"
  go get "github.com/madsportslab/glbs"
}

lerror()
{
  echo [Error: $1]
  exit
}

build_mcontroller()
{
  if [ -d $src1 ]; then
    log "Checking mcontroller dependencies"
    go_deps
    log "Compiling mcontroller"
    cd $src1
    go build

    if [ $? -eq 0 ]; then

      log "Completed"
      cp mcontroller $dir1
      log "Copied mcontroller to $dir1"

    else
      lerror "Compilation failed."
    fi

  else
    lerror "mcontroller sources not found."  
  fi

}

build_systemctl()
{
  cd $src2
  cp mcontroller.service $dir2
  log "Copied mcontroller.service to $dir2"
}

build_config()
{
  cd $src3
  cp $src3/config.json $dir1
  log "Copied config.json to $dir1"
}

build_debian()
{
  if [ -d $src1/debian/DEBIAN ]; then
    cd $src1/debian/DEBIAN
    cp * $dir3
    log "Copied debian package files to $dir3"
  else
    lerror "Debian sources not found."
  fi

  cd $HOME/build
  dpkg-deb --build mcontroller
  log "Generated package mcontroller.deb"
}

if ! [ -d $dst ]; then
  lerror "build directory not found."
  init_dir
fi

# mcontroller compilation

init_dir
build_mcontroller
build_systemctl
build_config
build_debian

