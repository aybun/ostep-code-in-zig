const std = @import("std");
const print = std.debug.print;
const sleep = std.time.sleep;
var m = std.Thread.Mutex{};
var c = std.Thread.Condition{};
// var done: i64 = 0;

fn child() !void {
    print("child: begin \n", .{});
    sleep(1 * std.time.ns_per_s);
    print("child: signal \n", .{});
    m.lock();
    // done = 1;
    c.signal();
    m.unlock();
}

pub fn main() !void {
    print("parent: begin\n", .{});
    _ = try std.Thread.spawn(.{}, child, .{});

    // print("parent: check condition\n", .{});
    // while (done == 0) {

    sleep(2 * std.time.ns_per_s);
    print("parent: wait to be signalled...\n", .{});
    m.lock();
    c.wait(&m);
    // }

    m.unlock();
    print("parent: end\n", .{});
}
