#!/bin/bash

mkdir -p ./build
rm -rf ./build/*
cd build && export CC=arm-none-eabi-gcc && export CXX=arm-none-eabi-g++ && cmake .. && cmake --build . && cd ..

