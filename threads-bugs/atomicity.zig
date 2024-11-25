const std = @import("std");

var num: i64 = 99;

fn thread_1() void {
    std.debug.print("t1 before check\n", .{});

    if (num == 99) {
        std.debug.print("t1 after check\n", .{});
        std.time.sleep(2_000_000); // 2 seconds

        std.debug.print("t1 in use!\n", .{});

        std.debug.print("num : {d}\n", .{num});
    }
}

fn thread_2() void {
    std.debug.print("t2 : begin\n", .{});

    std.time.sleep(1_000_000); //try changing this to 5

    std.debug.print("t2 : set to 0\n", .{});
    num = 0;
}

pub fn main() !void {
    if (std.os.argv.len != 1) {
        std.debug.print("usage: main\n", .{});
        return error.InvalidArgument;
    }

    std.debug.print("main: begin\n", .{});
    const t1 = try std.Thread.spawn(.{}, thread_1, .{});
    const t2 = try std.Thread.spawn(.{}, thread_2, .{});

    //Wait for both threads to finish
    t1.join();
    t2.join();

    std.debug.print("main: end", .{});
    return;
}
