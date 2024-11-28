const std = @import("std");
const print = std.debug.print;

const arg_t = struct { num_loops: i64, thread_id: i64 };

var forks: [5]std.Thread.Semaphore = undefined;
var print_lock: std.Thread.Semaphore = undefined;


fn space(s : i64) void{

    print_lock.wait();

    for (0 .. @intCast(s*10)) |_| {
        print(" ", .{});
    }
}

fn space_end() void {
    print_lock.post();
}



fn left(p: i64) i64 {
    return p;
}

fn right(p: i64) i64 {
    return @mod(p + 1, 5); // (p + 1) % 5
}

fn get_forks(p: i64) void {

        space(p); print("{d}: try {d}\n", .{ p, left(p) } ); space_end();
        forks[ @intCast(left(p))].wait();


        space(p); print("{d}: try {d}\n", .{ p, right(p) } ); space_end();
        forks[ @intCast(right(p))].wait();
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


        space(p); print("{d}: think\n", .{ p } ); space_end();
        think();

        get_forks(p);


        space(p); print("{d}: eat\n", .{ p } ); space_end();
        eat();


        put_forks(p);
        space(p); print("{d}: done\n", .{ p } ); space_end();
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

    //initialize print_lock
    print_lock = std.Thread.Semaphore{ .permits = 1 };

    //initialize threads
    var threads: [5]std.Thread = undefined;
    var a: [5]arg_t = undefined;

    for (0..5) |i| {
        a[i].num_loops = num_loops;
        a[i].thread_id = @intCast(i);
        threads[i] = try std.Thread.spawn(.{}, philosophers, .{&a[i]});
    }

    for (0..5) |i| {
        threads[i].join();
    }

    std.debug.print("Dining finished\n", .{});

    return;
}
