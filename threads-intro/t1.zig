const std = @import("std");

var counter: i64 = 0;
var max: i32 = 0;

fn worker(letter: []const u8) void {
    var i: i64 = 0;
    std.debug.print("{s}: begin [addr of i: {*}]\n", .{ letter, &i });
    while (i < max) : (i += 1) {
        counter = counter + 1; // shared: only one
    }
    std.debug.print("{s}: done\n", .{letter});
}

pub fn main() !void {
    if (std.os.argv.len != 2) {
        std.debug.print("usage: t1 <loops>\n", .{});
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
    max = std.fmt.parseInt(i32, args[1], 10) catch |err| {
        std.debug.print("Invalid number: {s}\n", .{args[1]});
        return err;
    };

    std.debug.print("main: begin [counter = [{d}] [{x}]\n", .{ counter, &counter });
    const thread_1 = try std.Thread.spawn(.{}, worker, .{"A"});
    const thread_2 = try std.Thread.spawn(.{}, worker, .{"B"});

    //Wait for both threads to finish
    thread_1.join();
    thread_2.join();

    std.debug.print("main: done\n [counter: {d}]\n [should: {d}]\n", .{ counter, max * 2 });
    return;
}
