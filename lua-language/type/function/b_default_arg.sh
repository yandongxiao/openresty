#!/bin/bash

function add()
{
    if [ "a$1" == "a" ]; then
        num1=0
    else
        num1=$1
    fi

    if [[ "b$2" == "b" ]]; then
        num2=0
    else
        num2=$2
    fi

    val=$(echo $num1 + $num2 | bc)
    echo $val
}

sum=$(add 1)
echo $sum
