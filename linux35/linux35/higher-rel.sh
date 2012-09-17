#!/bin/bash

for pkg in `ls | grep linux | grep -` ; do
echo "Edit ${pkg}"
pushd ${pkg} &>/dev/null
_rel=$(cat PKGBUILD | grep pkgrel= | cut -d= -f2)
sed -i -e "s/pkgrel=${_rel}/pkgrel=$((${_rel}+1))/" PKGBUILD
popd &>/dev/null
