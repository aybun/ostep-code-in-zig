// References
// https://cookbook.ziglang.cc/01-02-mmap-file.html
// and LLMs

const std = @import("std");
const fs = std.fs;
const print = std.debug.print;
const assert = std.debug.assert;

const PStack = struct {
    n: usize,
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Open the file
    const file = try fs.cwd().openFile("ps.img", .{ .mode = .read_write });
    defer file.close();

    // Get file stats
    const stat = try file.stat();
    const file_size = stat.size;

    // Verify file size
    assert(file_size >= @sizeOf(PStack));
    assert(file_size % @sizeOf(i32) == 0);

    // Memory map the file
    const buffer = try std.posix.mmap(
        null,
        file_size,
        std.posix.PROT.READ | std.posix.PROT.WRITE,
        .{ .TYPE = .SHARED },
        file.handle,
        0,
    );
    defer std.posix.munmap(buffer);

    // Get pointer to the stack structure
    var pstack: *PStack = @ptrCast(buffer.ptr);

    // Get the stack array portion
    const stack_start = buffer.ptr + @sizeOf(PStack);
    var stack = @as([*]i32, @ptrCast(stack_start))[0 .. (file_size - @sizeOf(PStack)) / @sizeOf(i32)];

    // Process arguments
    for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg, "pop")) {
            // Pop operation
            if (pstack.n > 0) {
                pstack.n -= 1;
                print("{d}\n", .{stack[pstack.n]});
            }
        } else {
            // Push operation
            const available_space = @sizeOf(PStack) + (1 + pstack.n) * @sizeOf(i32);
            if (available_space <= file_size) {
                const value = try std.fmt.parseInt(i32, arg, 10);
                stack[pstack.n] = value;
                pstack.n += 1;
            }
        }
    }
}
