#!/bin/bash
set -ex
arm-none-eabi-gcc -c -mcpu=arm926ej-s -g handler.c
arm-none-eabi-as -c -mcpu=arm926ej-s -g irq.s -o irq.o
arm-none-eabi-as -c -mcpu=arm926ej-s -g timer_init.s -o timer_init.o
arm-none-eabi-ld -T linker.ld handler.o irq.o timer_init.o -o test.elf
arm-none-eabi-objcopy -O binary test.elf test.bin
