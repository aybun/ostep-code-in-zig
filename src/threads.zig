//We dont actually need common_threads.zig for intro?
//
const std = @import("std");

var counter: i32 = 0; // shared
var loops: i32 = 0;

//fn worker(_args: *const u8) !void{
fn worker() !void {
    var i: i32 = 0;
    while (i < loops) : (i += 1) {
        counter += 1;
    }
}

pub fn main() !void {
    if (std.os.argv.len != 2) {
        std.debug.print("usage: threads <loops>\n");
        return error.InvalidArgument;
    }

    loops = std.fmt.parseInt(i32, std.os.argv[1], 10) catch |err| {
        std.debug.print("Invalid number: {}\n", .{std.os.argv[1]});
        return err;
    };

    std.debug.print("Initial value: {}\n", .{counter});
    const thread_1 = try std.Thread.spawn(worker, null);
    const thread_2 = try std.Thread.spawn(worker, null);

    //Wait for both threads to finish
    try thread_1.join();
    try thread_2.join();

    std.debug.print("Final value: \n", .{counter});
}
