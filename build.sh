#!/bin/bash

src1="$HOME/work/src/github.com/madsportslab/mboard-go"
src2="$HOME/src/madsportslab/mboard-electron"
src3="$HOME/work/src/github.com/madsportslab/mboard-www"
dst="$HOME/build/mboard"

function lerror {
  echo Error: $1
  exit
}

if ! [ -d $dst ]; then
  lerror "build directory not found."
fi

if [ -d $src1 ]; then
  echo "[compiling mboard-go...]"
  cd $src1
  go build
else
  lerror "mboard-go sources not found."  
fi
