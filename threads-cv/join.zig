const std = @import("std");
const print = std.debug.print;

var m = std.Thread.Mutex{};
var c = std.Thread.Condition{};
var done: i64 = 0;

fn child() !void {
    print("child\n", .{});
    std.time.sleep(1 * std.time.ns_per_s);
    m.lock();
    done = 1;
    c.signal();
    m.unlock();
}

pub fn main() !void {
    print("parent: begin\n", .{});
    _ = try std.Thread.spawn(.{}, child, .{});
    m.lock();

    while (done == 0) {
        c.wait(&m);
    }

    m.unlock();
    print("parent: end\n", .{});
}
