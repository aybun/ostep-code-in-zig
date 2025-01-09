const std = @import("std");

const myarg_t = struct {
    a: i64,
    b: i64,
};

const myret_t = struct {
    x: i64,
    y: i64,
};

fn worker(args: *myarg_t, rets: *myret_t) !void {
    std.debug.print("args {d} {d}\n", .{ args.a, args.b });

    rets.*.x = 1;
    rets.*.y = 2;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var args = myarg_t{
        .a = 10,
        .b = 20,
    };

    const rvals = try allocator.create(myret_t);
    defer allocator.destroy(rvals);

    const thread_1 = try std.Thread.spawn(.{}, worker, .{ &args, rvals });

    thread_1.join();

    std.debug.print("returned {d} {d}\n", .{ rvals.*.x, rvals.*.y });
}
