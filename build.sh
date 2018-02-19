#!/bin/bash

src1="$HOME/work/src/github.com/madsportslab/mboard-go"
src2="$HOME/src/madsportslab/mboard-electron"
src3="$HOME/work/src/github.com/madsportslab/mboard-www"
src4="$src1/debian/etc/systemd/system"
src5="$src1/debian/home/mboard/.config/autostart"
src6="$HOME/work/src/github.com/mattes/migrate"
src7="$HOME/web"
src8="$HOME/electron"
dst1="$HOME/build/mboard"
dir1="$HOME/build/mboard/home/mboard/bin"
dir2="$HOME/build/mboard/home/mboard/bin/electron"
dir3="$HOME/build/mboard/etc/systemd/system"
dir4="$HOME/build/mboard/DEBIAN"
dir5="$HOME/build/mboard/home/mboard/.config/autostart"
dir6="$HOME/build/mboard/home/mboard/bin/mboard-www"
dir7="$HOME/build/mboard/home/mboard/bin/electron/resources"
dir8="$HOME/build/mboard/home/mboard/data/migrations"

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
  build_dir $dir4
  build_dir $dir5
  build_dir $dir6
  build_dir $dir8
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
  go get "github.com/mattn/go-sqlite3"
  go get "github.com/skip2/go-qrcode"
  go get "github.com/mattes/migrate/cli"
}

lerror()
{
  echo [Error: $1]
  exit
}

build_mboard()
{
  if [ -d $src1 ]; then
    log "Checking mboard-go dependencies"
    go_deps
    log "Compiling mboard-go"
    cd $src1
    go build

    if [ $? -eq 0 ]; then

      log "Completed"
      cp mboard-go $dir1
      log "Copied mboard-go to $dir1"

    else
      lerror "Compilation failed."
    fi

  else
    lerror "mboard-go sources not found."  
  fi

}

build_electron()
{
  if [ -d $src8 ]; then

    cp -R $src8 $dir1
    log "Copied electron binaries to $dir1"

  else
    lerror "Electron binaries not found."
  fi
}

build_mboard_electron()
{
  if [ -d $src2 ]; then

    cd $src2
    npm install
    cd ..
    asar pack mboard-electron mboard-electron.asar
    cp mboard-electron.asar $dir7
    log "Copied mboard-electron.asar to $dir7"

  else
    lerror "mboard-electron sources not found."
  fi
}

build_mboard_www()
{
  if [ -d $src3 ]; then
    cd $src3
    cp *.amber $dir6
    log "Copied amber web templates to $dir6"
    cp -R css $dir6
    cp -R js $dir6
    log "Copied css and js assets to $dir6"
    cd $src7
    cp -R * $dir6
    log "Copied material-components-web and font-awesome to $dir6"
  else
    lerror "$src3 not found"
  fi
}

build_migrations()
{
  if [ -d $src1/db/migrations ]; then

    cd $src1/db/migrations
    cp *.sql $dir8
    log "Copied database migrations to $dir8"

  else
    lerror "Database migrations not found."
  fi
}

build_systemctl()
{
  cd $src4
  cp mboard.service $dir3
  log "Copied mboard.service to $dir3"
}

build_autostart()
{
  cd $src5
  cp mboard-electron.desktop $dir5
  log "Copied mboard.desktop to $dir5"
}

build_migrate()
{
  if [ -d $src6 ]; then
    cd $src6
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
    cp * $dir4
    log "Copied debian package files to $dir4"
  else
    lerror "Debian sources not found."
  fi

  cd $HOME/build
  dpkg-deb --build mboard
  log "Generated package mboard.deb"
}

if ! [ -d $dst ]; then
  lerror "build directory not found."
  init_dir
fi

# mboard-go compilation

clean
init_dir
build_mboard
build_electron
build_mboard_electron
build_mboard_www
build_migrations
build_migrate
build_systemctl
build_autostart
build_debian

