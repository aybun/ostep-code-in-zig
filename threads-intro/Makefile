
all: t0 t1

clean:
	rm -f t0 t1
	rm -f t0.o t1.o

t0:
	zig build-exe t0.zig 
	rm -f t0.o

t1:
	zig build-exe t1.zig
	rm -f t1.o
