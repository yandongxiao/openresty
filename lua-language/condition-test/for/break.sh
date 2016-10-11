#!/bin/bash

for x in `seq 1 3`
do
  if [ $x -eq 2 ]; then
      break
  fi
  echo $x
done
