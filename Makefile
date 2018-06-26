CXX:=clang++
CFLAGS:=-std=c++17 -Wall -pedantic -static

LINKER:=ld.lld
LFLAGS:=-Bstatic
LIBS=/usr/lib/libstdc++.a
LIBS+=/usr/lib/gcc/x86_64-pc-linux-gnu/8.1.1/libgcc_eh.a
LIBS+=/usr/lib/gcc/x86_64-pc-linux-gnu/8.1.1/libgcc.a
LIBS+=/usr/lib/libc.a
LIBS+=/usr/lib/crt1.o /usr/lib/crti.o /usr/lib/crtn.o

main: main.o Makefile
	$(LINKER) $(LFLAGS) -o $@ $< $(LIBS)

main.o: main.cpp Makefile
	$(CXX) $(CFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	rm -rf main.o main
