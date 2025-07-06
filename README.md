# NASM Win32 Projects

This repository contains simple projects written in **NASM (Netwide Assembler)** for the **Win32** platform. These examples demonstrate how to build native Windows executables using NASM and GCC for linking.

## 🔧 Requirements

To build the projects, you need:

- [NASM](https://www.nasm.us/) – the Netwide Assembler
- [GCC for Windows (MinGW)](https://www.mingw-w64.org/) – for linking
- Optional: a terminal (e.g., Git Bash, CMD, or PowerShell)

> Make sure both `nasm` and `gcc` are in your system `PATH`.

---

## 🛠 Build Instructions

Each project contains one or more `.asm` files. To assemble and link them, use the following commands:

```bash
nasm -f win32 prog.asm -o prog.o
gcc -m32 prog.o -o prog.exe -lkernel32 -luser32

