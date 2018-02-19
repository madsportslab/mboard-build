#!/bin/bash

src1="$HOME/work/src/github.com/madsportslab/madsportslab-service"
src2="$src1/debian/etc/systemd/system"
src3="$HOME/work/src/github.com/mattes/migrate"
dst1="$HOME/build/madsportslab"
dir1="$dst1/home/madsportslab/bin"
dir2="$dst1/etc/systemd/system"
dir3="$dst1/DEBIAN"
dir4="$dst1/home/madsportslab/data/migrations"

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
  go get "github.com/mattn/go-sqlite3"
  go get "github.com/mattes/migrate/cli"
  go get "github.com/madsportslab/glbs"
}

lerror()
{
  echo [Error: $1]
  exit
}

build_madsportslab_service()
{
  if [ -d $src1 ]; then
    log "Checking madsportslab-service dependencies"
    go_deps
    log "Compiling madsportslab-service"
    cd $src1
    go build

    if [ $? -eq 0 ]; then

      log "Completed"
      cp madsportslab-service $dir1
      log "Copied madsportslab-service to $dir1"

    else
      lerror "Compilation failed."
    fi

  else
    lerror "madsportslab-service sources not found."  
  fi

}

build_migrations()
{
  if [ -d $src1/db/migrations ]; then

    cd $src1/db/migrations
    cp *.sql $dir4
    log "Copied database migrations to $dir4"

  else
    lerror "Database migrations not found."
  fi
}

build_systemctl()
{
  cd $src2
  cp madsportslab.service $dir2
  log "Copied madsportslab.service to $dir2"
}

build_migrate()
{
  if [ -d $src3 ]; then
    cd $src3
    go build -tags "sqlite3" -o migrate github.com/mattes/migrate/cli

    if [ $? -eq 0 ]; then
      cp migrate $dir1
      log "Copied migrate to $dir1"
    else
      lerror "Compilation failed for migrate."
    fi
  else
    lerror "Sources not found for $src6"
  fi
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
  dpkg-deb --build madsportslab
  log "Generated package madsportslab.deb"
}

if ! [ -d $dst ]; then
  lerror "build directory not found."
  init_dir
fi

# madsportslab-service compilation

build_madsportslab_service
build_migrations
build_migrate
build_systemctl
build_debian

