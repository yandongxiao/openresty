#!/bin/bash

function add()
{
    val=$(echo $1 + $2 | bc)
    echo $val
}

sum=$(add 1 2)
echo $sum
