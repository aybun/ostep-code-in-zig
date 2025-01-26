const std = @import("std");
const print = std.debug.print;

var max: i32 = undefined;
var loops: i32 = undefined;
var buffer: []i32 = undefined;

var use_ptr: i32 = 0;
var fill_ptr: i32 = 0;
var num_full: i32 = 0;

var empty = std.Thread.Condition{};
var fill = std.Thread.Condition{};
var m = std.Thread.Mutex{};

var consumers: i32 = 1;
var verbose: i32 = 1;

fn do_fill(value: i32) void {
    buffer[@intCast(fill_ptr)] = value;
    fill_ptr = @mod(fill_ptr + 1, max);
    num_full = num_full + 1;
}

fn do_get() i32 {
    const tmp = buffer[@intCast(use_ptr)];
    use_ptr = @mod(use_ptr + 1, max);
    num_full = num_full - 1;
    return tmp;
}

fn producer() void {
    for (0..@intCast(loops)) |i| {
        m.lock();
        while (num_full == max) {
            empty.wait(&m);
        }
        do_fill(@intCast(i));
        fill.signal();
        m.unlock();
    }

    // end case: put an end-of-production marker (-1)
    // into shared buffer, one per consumer

    for (0..@intCast(consumers)) |_| {
        m.lock();
        while (num_full == max) {
            empty.wait(&m);
        }
        do_fill(-1);
        fill.signal();
        m.unlock();
    }
}

fn consumer() void {
    var tmp: i32 = 0;

    while (tmp != -1) {
        m.lock();
        while (num_full == 0) {
            fill.wait(&m);
        }
        tmp = do_get();
        empty.signal();
        m.unlock();
    }
}

pub fn main() !void {
    if (std.os.argv.len != 4) {
        std.debug.print("usage: pc <buffersize> <loops> <consumer>\n", .{});
        return error.InvalidArgument;
    }

    //allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    //args allocation
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    max = try std.fmt.parseInt(i32, args[1], 10);
    loops = try std.fmt.parseInt(i32, args[2], 10);
    consumers = try std.fmt.parseInt(i32, args[3], 10);

    buffer = try allocator.alloc(i32, @intCast(max));
    @memset(buffer, 0);
    defer allocator.free(buffer);

    //spawn
    const pid = try std.Thread.spawn(.{}, producer, .{});

    const cid: []std.Thread = try allocator.alloc(std.Thread, @intCast(consumers));
    defer allocator.free(cid);
    for (0..@intCast(consumers)) |i| {
        cid[i] = try std.Thread.spawn(.{}, consumer, .{});
    }

    //join
    pid.join();
    for (cid) |c| {
        c.join();
    }
}
