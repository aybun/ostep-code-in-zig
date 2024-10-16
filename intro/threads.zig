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
        std.debug.print("usage: threads <loops>\n", .{});
        return error.InvalidArgument;
    }

    //allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    //args allocation
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    //args parsing
    loops = std.fmt.parseInt(i32, args[1], 10) catch |err| {
        std.debug.print("Invalid number: {s}\n", .{args[1]});
        return err;
    };

    std.debug.print("Initial value: {}\n", .{counter});
    const thread_1 = try std.Thread.spawn(.{}, worker, .{});
    const thread_2 = try std.Thread.spawn(.{}, worker, .{});

    //Wait for both threads to finish
    thread_1.join();
    thread_2.join();

    std.debug.print("Final value: {d}\n", .{counter});

    return;
}
