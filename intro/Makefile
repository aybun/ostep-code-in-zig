
all:
	make cpu
	make mem
	make threads
	make io

clean:
	rm -f cpu cpu.o mem mem.o threads threads.o io io.o

cpu:
	zig build-exe cpu.zig
	rm -f cpu.o

mem:
	zig build-exe mem.zig
	rm -f mem.o

threads:
	zig build-exe threads.zig
	rm -f threads.o

io:
	zig build-exe io.zig
	rm -f io.o

