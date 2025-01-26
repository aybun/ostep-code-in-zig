const std = @import("std");
const print = std.debug.print;

const synchronizer_t = struct {
    m: std.Thread.Mutex,
    c: std.Thread.Condition,
    done: i64,

    fn sync_init(s: *synchronizer_t) void {
        s.done = 0;
        s.m = std.Thread.Mutex{};
        s.c = std.Thread.Condition{};
    }

    fn sync_signal(s: *synchronizer_t) void {
        s.m.lock();
        s.done = 1;
        s.c.signal();
        s.m.unlock();
    }

    fn sync_wait(s: *synchronizer_t) void {
        s.m.lock();
        while (s.done == 0) {
            s.c.wait(&(s.*.m));
        }
        s.done = 0; // reset for next use
        s.m.unlock();
    }
};

var sync: synchronizer_t = undefined;

fn child() !void {
    print("child\n", .{});
    std.time.sleep(1 * std.time.ns_per_s);
    sync.sync_signal();
}

pub fn main() !void {
    print("parent: begin\n", .{});
    sync.sync_init();
    _ = try std.Thread.spawn(.{}, child, .{});
    sync.sync_wait();
    print("parent: end\n", .{});
}
