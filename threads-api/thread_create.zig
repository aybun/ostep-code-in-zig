const std = @import("std");

const myarg_t = struct {
    a: i64,
    b: i64,
};

fn worker(args: *myarg_t) void {
    std.debug.print("{d} {d}\n", .{ args.*.a, args.b }); //explicit, implicit
}

pub fn main() !void {
    var args = myarg_t{
        .a = 10,
        .b = 20,
    };

    const thread_1 = try std.Thread.spawn(.{}, worker, .{&args});

    thread_1.join();
    std.debug.print("done\n", .{});
}
