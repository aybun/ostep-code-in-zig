const std = @import("std");

fn worker(str: []const u8) void {
    std.debug.print("{s}\n", .{str});
}

pub fn main() !void {
    if (std.os.argv.len != 1) {
        std.debug.print("usage: t0\n", .{});
        return error.InvalidArgument;
    }

    std.debug.print("main: begin\n", .{});
    const thread_1 = try std.Thread.spawn(.{}, worker, .{"A"});
    const thread_2 = try std.Thread.spawn(.{}, worker, .{"B"});

    //Wait for both threads to finish
    thread_1.join();
    thread_2.join();

    std.debug.print("main: end\n", .{});
    return;
}
