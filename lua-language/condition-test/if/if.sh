#!/bin/bash

num=2
if [ $num -eq 1 ]; then
    echo One
elif [ $num -eq 2 ]; then   # 注意关键字elif
    echo Two
else
    echo Three
fi
