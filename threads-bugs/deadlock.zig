const std = @import("std");
const print = std.debug.print;

var L1 = std.Thread.Mutex{};
var L2 = std.Thread.Mutex{};

fn thread1() void {
    print("t1: begin\n", .{});
    print("t1: try to acquire L1...\n", .{});
    L1.lock();
    print("t1: L1 acquired\n", .{});
    print("t1: try to acquire L2...\n", .{});
    L2.lock();
    print("t1: L2 acquired\n", .{});
    L1.unlock();
    L2.unlock();
}

fn thread2() void {
    print("                           t2: begin\n", .{});
    print("                           t2: try to acquire L2...\n", .{});
    L2.lock();
    print("                           t2: L2 acquired\n", .{});
    print("                           t2: try to acquire L1...\n", .{});
    L1.lock();
    print("                           t2: L1 acquired\n", .{});
    L1.unlock();
    L2.unlock();
}

pub fn main() !void {
    if (std.os.argv.len != 1) {
        std.debug.print("usage: main\n", .{});
        return error.InvalidArgument;
    }

    std.debug.print("main: begin\n", .{});
    const p1 = try std.Thread.spawn(.{}, thread1, .{});
    const p2 = try std.Thread.spawn(.{}, thread2, .{});

    //Wait for both threads to finish
    p1.join();
    p2.join();

    std.debug.print("main: end", .{});
    return;
}
