const std = @import("std");
const print = std.debug.print;
const getpid = std.os.linux.getpid;
const fork = std.os.linux.fork;
const exit = std.process.exit;

pub fn main() !void {
    std.debug.print("hello world (pid:{d})\n", .{getpid()});
    const rc = fork();

    if (rc < 0) {
        print("fork failed\n", .{});
        exit(1);
    } else if (rc == 0) {
        print("hello, I am child (pid:{d})\n", .{getpid()});
    } else {
        print("hello I am parent of {d} (pid:{d})\n", .{ rc, getpid() });
    }

    return;
}
