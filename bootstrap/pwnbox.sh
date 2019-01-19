# Packages
install_package build-essential cmake
install_package libc6:i386 libc6-dev-i386 libncurses5:i386 libstdc++6:i386 # libraries (32 bits)
install_package libc6-dbg:i386 libc6-dbg
install_package gcc-multilib g++-multilib gcc-arm-none-eabi
install_package gdb gdb-multiarch
install_package socat netcat nmap net-tools wget ssh
install_package nasm
install_package ctags
install_package binwalk exiftool
install_package strace ltrace
install_package unzip
install_package qemu qemu-user qemu-user-static

install python
install python dev

install vim
install tmux

install zsh

install fzf

install peda
install gef # will install ropper on python3
install radare2
install ropper
install pwntools