const std = @import("std");

const arg_t = struct { num_loops: i64, thread_id: i64 };

var forks: [5]std.Thread.Semaphore = undefined;

fn left(p: i64) i64 {
    return p;
}

fn right(p: i64) i64 {
    return @mod(p + 1, 5);
}

fn get_forks(p: i64) void {
    if (p == 4) {
        forks[ @intCast(right(p))].wait();
        forks[ @intCast(left(p))].wait();
    } else {
        forks[ @intCast(left(p))].wait();
        forks[ @intCast(right(p))].wait();
    }
}

fn put_forks(p: i64) void {
    forks[ @intCast(left(p))].post();
    forks[ @intCast(right(p))].post();
}

fn eat() void {
    return;
}

fn think() void {
    return;
}

fn philosophers(arg: *arg_t) void {
    const p: i64 = arg.*.thread_id;

    for (0.. @intCast(arg.*.num_loops) ) |_| {
        think();
        get_forks(p);
        eat();
        put_forks(p);
    }

    return;
}

pub fn main() !void {
    if (std.os.argv.len != 2) {
        std.debug.print("usage: dining_philosophers <loops>\n", .{});
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
    const num_loops = std.fmt.parseInt(i32, args[1], 10) catch |err| {
        std.debug.print("Invalid number: {s}\n", .{args[1]});
        return err;
    };

    //initialize forks
    for (0..5) |i| {
        forks[i] = std.Thread.Semaphore{ .permits = 1 };
    }

    var threads: [5]std.Thread = undefined;
    var a: [5]arg_t = undefined;

    for (0..5) |i| {
        a[i].num_loops = num_loops;
        a[i].thread_id = @intCast(i);
        threads[i] = try std.Thread.spawn(.{}, philosophers, .{&a[i]});
    }

    // const thread_1 = try std.Thread.spawn(.{}, worker, .{});
    for (0..5) |i| {
        threads[i].join();
    }

    std.debug.print("Dining finished\n", .{});

    return;
}
