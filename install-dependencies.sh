#!/usr/bin/env bash

test -n "$SRC_PREFIX" || {
SRC_PREFIX=$HOME
}

test -n "$PREFIX" || {
PREFIX=$HOME/usr
}

test -n "$SRC_PREFIX" || {
  echo "Not sure where checkout"
  exit 1
}

test -n "$PREFIX" || {
  echo "Not sure where to install"
  exit 1
}

test -d $SRC_PREFIX || mkdir -vp $SRC_PREFIX
test -d $PREFIX || mkdir -vp $PREFIX


install_bats()
{
  echo "Installing bats"
  pushd $SRC_PREFIX
  git clone https://github.com/sstephenson/bats.git
  cd bats
  ./install.sh $PREFIX
  popd
}

# Check for BATS shell test runner or install
test -x "$(which bats)" || {
  install_bats
  export PATH=$PATH:$PREFIX/bin
}

bats --version

# Id: mkdoc/0 install-dependencies.sh
