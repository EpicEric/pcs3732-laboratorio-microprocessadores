#!/bin/bash
set -e
arm-none-eabi-gcc -c -mcpu=arm926ej-s -g c_entry.c
arm-none-eabi-as -c -mcpu=arm926ej-s -g startup.s -o startup.o
arm-none-eabi-ld -T linker.ld c_entry.o startup.o -o test.elf
arm-none-eabi-objcopy -O binary test.elf test.bin
