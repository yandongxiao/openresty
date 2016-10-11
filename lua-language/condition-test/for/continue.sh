#!/bin/bash

for x in `seq 1 3`
do
  if [ $x -eq 2 ]; then
      continue
  fi
  echo $x
done
