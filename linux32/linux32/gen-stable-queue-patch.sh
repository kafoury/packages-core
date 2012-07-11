#!/bin/bash
source PKGBUILD

if [ -d linux-3.2.y-queue ] ;
then
  cd linux-3.2.y-queue
  git pull
  cd ..
else
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-3.2.y-queue.git
fi

if [ -d linux-3.2.y-queue/queue-$_basekernel ] ;
then
  cd linux-3.2.y-queue/queue-$_basekernel

  for i in $(cat ./series); 
  do 
     cat $i >> ../../prepatch-$_basekernel-`date +%Y%m%d`; 
  done
else
  echo "There is no patch-set this time"
fi
