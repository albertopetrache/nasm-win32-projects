@echo off
set "SRC=toupper.asm"
set "OBJ=toupper.o"
set "EXE=toupper.exe"

echo [1/3] Assembling with NASM...
nasm -f win32 %SRC% -o %OBJ%
if errorlevel 1 goto :error

echo [2/3] Linking with GCC...
gcc -m32 %OBJ% -o %EXE% -lkernel32 -luser32
if errorlevel 1 goto :error

echo [3/3] Build successful! Running program...
%EXE%
goto :eof

:error
echo.
echo Build failed!
exit /b 1
