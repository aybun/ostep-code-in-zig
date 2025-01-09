const std = @import("std");
const print = std.debug.print;
const getpid = std.os.linux.getpid;
const fork = std.os.linux.fork;
const exit = std.process.exit;
//p2.zig
const sleep = std.time.sleep;
const waitpid = std.os.linux.waitpid;

// This example shows how to wait for the child process to finish.
// Next, How do I exit with an arbitrary flag?
pub fn main() !void {
    std.debug.print("hello world (pid:{d})\n", .{getpid()});
    const rc = fork();

    if (rc < 0) {
        print("fork failed\n", .{});
        exit(1);
    } else if (rc == 0) {
        print("hello, I am child (pid:{d})\n", .{getpid()});
        sleep(1 * std.time.ns_per_s);
    } else {

        //https://ratfactor.com/zig/forking-is-cool
        var temp: u32 = 998877; // Why do we need this
        const wait_result = waitpid(@intCast(rc), &temp, 0); //Does the last argument have something to do with wait_result?

        if (wait_result != 0) {
            print("hello I am parent of {d} (pid:{d})\n", .{ rc, getpid() });
        }
    }
}
