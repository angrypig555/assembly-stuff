#!/bin/bash

input="$1"

if [[ "$1" == "" ]] ; then
    echo "error: no input file"
    exit 1
else
    nasm -f elf32 $1 -o helloworld.o
    ld -m elf_i386 helloworld.o -o helloworld
    echo "Build complete"
    exit 0
fi