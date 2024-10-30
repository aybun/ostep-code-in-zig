const std = @import("std");

fn worker(value: *i64) void {
    value.* += 1;
}

pub fn main() !void {
    var rvalue: i64 = 100;
    const thread_1 = try std.Thread.spawn(.{}, worker, .{&rvalue});

    thread_1.join();

    std.debug.print("returned {d}\n", .{rvalue});
}
