CXX:=clang++
CFLAGS:=-std=c++17 -Wall -pedantic -static

LINKER:=ld
LFLAGS:=-static -m elf_x86_64
LSRCH=-L/usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1
LSRCH+=-L/usr/lib64
LSRCH+=-L/usr/lib

LIBS=/usr/lib64/crt1.o
LIBS+=/usr/lib64/crti.o
LIBS+=/usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtbeginT.o
LIBS+=-lstdc++
LIBS+=-lm
LIBS+=--start-group -lgcc -lgcc_eh -lc --end-group
LIBS+=/usr/lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtend.o
LIBS+=/usr/lib64/crtn.o

# Command line from "clang++ -v -static main.cpp" as advised from Shoaib Meenai.
# See http://lists.llvm.org/pipermail/cfe-dev/2018-June/058293.html
#
#/usr/bin/ld" -m elf_x86_64 -static -o a.out /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64/crt1.o /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64/crti.o /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtbeginT.o -L/usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1 -L/usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64 -L/usr/bin/../lib64 -L/lib/../lib64 -L/usr/lib/../lib64 -L/usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../.. -L/usr/bin/../lib -L/lib -L/usr/lib /tmp/main-dd34a5.o -lstdc++ -lm --start-group -lgcc -lgcc_eh -lc --end-group /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/crtend.o /usr/bin/../lib64/gcc/x86_64-pc-linux-gnu/8.1.1/../../../../lib64/crtn.o

main: main.o Makefile
	$(LINKER) $(LFLAGS) -o $@ $< $(LSRCH) $(LIBS)

main.o: main.cpp Makefile
	$(CXX) $(CFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	rm -rf main.o main
