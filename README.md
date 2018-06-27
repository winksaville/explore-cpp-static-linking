# Static linking cpp program

Compiles and links and runs:
```
$ make clean && make && ./main 1 2 3
rm -rf main.o main
clang++ -std=c++17 -Wall -pedantic -static -c -o main.o main.cpp
ld -static -m elf_x86_64 -o main main.o -L/usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1 -L/usr/lib64 -L/usr/lib /usr/lib64/crt1.o /usr/lib64/crti.o /usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtbeginT.o -lstdc++ -lm --start-group -lgcc -lgcc_eh -lc --end-group /usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtend.o /usr/lib64/crtn.o
argv[0]: ./main
argv[1]: 1
argv[2]: 2
argv[3]: 3
```

An interesting side note is that using ld.lld fails
with a seg fault:
```
$ clang++ -v -fuse-ld=lld -static main.cpp -o main
clang version 6.0.0 (tags/RELEASE_600/final)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-pc-linux-gnu/8.1.1
Found candidate GCC installation: /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1
Found candidate GCC installation: /usr/lib/gcc/x86_64-pc-linux-gnu/8.1.1
Found candidate GCC installation: /usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1
Selected GCC installation: /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1
Candidate multilib: .;@m64
Candidate multilib: 32;@m32
Selected multilib: .;@m64
 "/usr/bin/clang-6.0" -cc1 -triple x86_64-pc-linux-gnu -emit-obj -mrelax-all -disable-free -disable-llvm-verifier -discard-value-names -main-file-name main.cpp -static-define -mrelocation-model pic -pic-level 2 -pic-is-pie -mthread-model posix -mdisable-fp-elim -fmath-errno -masm-verbose -mconstructor-aliases -munwind-tables -fuse-init-array -target-cpu x86-64 -dwarf-column-info -debugger-tuning=gdb -v -resource-dir /usr/lib/clang/6.0.0 -internal-isystem /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../include/c++/8.1.1 -internal-isystem /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../include/c++/8.1.1/x86_64-pc-linux-gnu -internal-isystem /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../include/c++/8.1.1/backward -internal-isystem /usr/local/include -internal-isystem /usr/lib/clang/6.0.0/include -internal-externc-isystem /include -internal-externc-isystem /usr/include -fdeprecated-macro -fdebug-compilation-dir /home/wink/prgs/explore-cpp-static-linking -ferror-limit 19 -fmessage-length 121 -stack-protector 2 -fobjc-runtime=gcc -fcxx-exceptions -fexceptions -fdiagnostics-show-option -fcolor-diagnostics -o /tmp/main-dc372d.o -x c++ main.cpp
clang -cc1 version 6.0.0 based upon LLVM 6.0.0 default target x86_64-pc-linux-gnu
ignoring nonexistent directory "/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../include/c++/8.1.1
 /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../include/c++/8.1.1/x86_64-pc-linux-gnu
 /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../include/c++/8.1.1/backward
 /usr/local/include
 /usr/lib/clang/6.0.0/include
 /usr/include
End of search list.
 "/usr/bin/ld.lld" -m elf_x86_64 -static -o main /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64/crt1.o /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64/crti.o /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtbeginT.o -L/usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1 -L/usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64 -L/usr/bin/../lib64 -L/lib/../lib64 -L/usr/lib/../lib64 -L/usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../.. -L/usr/bin/../lib -L/lib -L/usr/lib /tmp/main-dc372d.o -lstdc++ -lm --start-group -lgcc -lgcc_eh -lc --end-group /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtend.o /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64/crtn.o

$ ./main
Segmentation fault (core dumped)

$ coredumpctl gdb
           PID: 5549 (main)
           UID: 1000 (wink)
           GID: 100 (users)
        Signal: 11 (SEGV)
     Timestamp: Tue 2018-06-26 22:33:47 PDT (1min 14s ago)
  Command Line: ./main
    Executable: /home/wink/prgs/explore-cpp-static-linking/main
 Control Group: /user.slice/user-1000.slice/session-c2.scope
          Unit: session-c2.scope
         Slice: user-1000.slice
       Session: c2
     Owner UID: 1000 (wink)
       Boot ID: 65910f0244bf4b62905c0198842b62d4
    Machine ID: 8f80fd742eae4659baed812cd07a9439
      Hostname: wink-desktop
       Storage: /var/lib/systemd/coredump/core.main.1000.65910f0244bf4b62905c0198842b62d4.5549.1530077627000000.lz4
       Message: Process 5549 (main) of user 1000 dumped core.

                Stack trace of thread 5549:
                #0  0x0000000000383dc6 n/a (/home/wink/prgs/explore-cpp-static-linking/main)

GNU gdb (GDB) 8.1
Copyright (C) 2018 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /home/wink/prgs/explore-cpp-static-linking/main...(no debugging symbols found)...done.
[New LWP 5549]
Core was generated by `./main'.
Program terminated with signal SIGSEGV, Segmentation fault.
#0  0x0000000000383dc6 in _dl_get_origin ()
(gdb) bt
#0  0x0000000000383dc6 in _dl_get_origin ()
#1  0x000000000038342f in _dl_non_dynamic_init ()
#2  0x00000000002eecd1 in __libc_init_first ()
#3  0x00000000002ee9c7 in __libc_start_main ()
#4  0x000000000025302a in _start ()
```
