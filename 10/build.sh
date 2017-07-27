#!/bin/bash
set -ex
arm-none-eabi-as -c -mcpu=arm926ej-s -g handler.s -o handler.o
arm-none-eabi-as -c -mcpu=arm926ej-s -g irq.s -o irq.o
arm-none-eabi-ld -T linker.ld handler.o irq.o -o test.elf
arm-none-eabi-objcopy -O binary test.elf test.bin
