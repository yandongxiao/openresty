#!/bin/bash

num=1
function fn()
{
  local num=2
  if [ 1 -eq 1 ]; then
    local num=3
    echo $num
  fi
  echo $num
}

fn
echo $num
