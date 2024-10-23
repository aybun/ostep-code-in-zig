const std = @import("std");
const print = std.debug.print;
const getpid = std.os.linux.getpid;
const fork = std.os.linux.fork;
const exit = std.process.exit;
const sleep = std.time.sleep;
const waitpid = std.os.linux.waitpid;

pub fn main() !void {
    print("hello world (pid:{d})\n", .{getpid()});
    const rc = fork();

    if (rc < 0) {
        print("fork failed\n", .{});
        exit(1);
    } else if (rc == 0) {
        // Child process
        // done via LLM

        print("hello, I am child (pid:{d})\n", .{getpid()});

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        defer _ = gpa.deinit();
        const allocator = gpa.allocator();

        const file = try std.fs.cwd().createFile("p4.output", .{});
        defer file.close();

        const command = [_][]const u8{ "wc", "p4.zig" };
        const result = try std.process.Child.run(.{
            .allocator = allocator,
            .argv = &command,
        });
        defer allocator.free(result.stdout);
        defer allocator.free(result.stderr);

        _ = try file.writeAll(result.stdout);
    } else {

        //https://ratfactor.com/zig/forking-is-cool
        var temp: u32 = 998877; // Why do we need this
        const wait_result = waitpid(@intCast(rc), &temp, 0); //Does the last argument have something to do with wait_result?

        if (wait_result != 0) {
            print("hello I am parent of {d} (pid:{d})\n", .{ rc, getpid() });
        }
    }
}
