//Reference : https://medium.com/@mikecode/zig-93-mutex-ffc339e409ba

const std = @import("std");

var proc_info_lock = std.Thread.Mutex{};
const proc_t = struct { pid: i32 };
const thread_info_t = struct { proc_info: ?*proc_t };

var p: proc_t = undefined;
// var th: thread_info_t = undefined;
var thd: *thread_info_t = undefined;

fn thread_1() void {
    std.debug.print("t1 before check\n", .{});

    proc_info_lock.lock();

    if (thd.*.proc_info != null) {
        std.debug.print("t1 after check\n", .{});
        std.time.sleep(2 * std.time.ns_per_s); // 2 seconds
        std.debug.print("t1 in use!\n", .{});
        std.debug.print("{d}\n", .{thd.*.proc_info.?.*.pid});
    }

    proc_info_lock.unlock();
}

fn thread_2() void {
    std.debug.print("t2 : begin\n", .{});
    std.time.sleep(1 * std.time.ns_per_s); // change to 5 to make the code "work"...

    proc_info_lock.lock();

    std.debug.print("t2 : set to null\n", .{});
    thd.*.proc_info = null;

    proc_info_lock.unlock();
}

pub fn main() !void {
    if (std.os.argv.len != 1) {
        std.debug.print("usage: main\n", .{});
        return error.InvalidArgument;
    }

    var t: thread_info_t = undefined;
    p.pid = 100;
    t.proc_info = &p;
    thd = &t;

    std.debug.print("main: begin\n", .{});
    const t1 = try std.Thread.spawn(.{}, thread_1, .{});
    const t2 = try std.Thread.spawn(.{}, thread_2, .{});

    //Wait for both threads to finish
    t1.join();
    t2.join();

    std.debug.print("main: end", .{});
    return;
}
