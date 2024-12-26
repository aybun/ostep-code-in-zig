
clean:
	rm -f atomicity atomicity_fixed ordering ordering_fixed
	rm -f atomicity.o atomicity_fixed.o ordering.o ordering_fixed.o

atomicity:
	zig build-exe atomicity.zig
	rm -f atomicity.o

atomicity_fixed:
	zig build-exe atomicity_fixed.zig
	rm -f atomicity_fixed.o

ordering:
	zig build-exe ordering.zig
	rm -f ordering.o

ordering_fixed:
	zig build-exe ordering_fixed.zig
	rm -f ordering_fixed.o


