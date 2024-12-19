//random : From Loris Cro's comment
//https://zig.news/gowind/how-to-use-the-random-number-generator-in-zig-ef6#comment-45

const std = @import("std");

//allocator
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();
// defer _ = gpa.deinit();
var gtickets: i32 = 0;

const node_t = struct {
    tickets: i32,
    next: ?*@This(), //?*node_t
};

// Info on Optional : https://ziglang.org/documentation/master/#toc-Optional-Pointers
var head: ?*node_t = null;

fn insert(tickets: i32) !void {
    const tmp = try allocator.create(node_t);
    tmp.*.tickets = tickets;
    tmp.*.next = head;
    head = tmp;
    gtickets += tickets;
}

fn print_list() void {
    var curr = head;
    std.debug.print("List: ", .{});

    while (curr != null) {
        std.debug.print("[{d}] ", .{curr.?.*.tickets});
        curr = curr.?.*.next;
    }
    std.debug.print("\n", .{});
}

pub fn main() !void {
    if (std.os.argv.len != 3) {
        std.debug.print("usage: lottery <seed> <loops>\n", .{});
        return error.InvalidArgument;
    }

    //args allocation
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    //args parsing
    const seed = try std.fmt.parseInt(i32, args[1], 10);
    const loops = try std.fmt.parseInt(i32, args[2], 10);
    std.debug.print("seed: {d}\nloops : {d}\n", .{ seed, loops });
    // Random
    var rand_impl = std.rand.DefaultPrng.init(@intCast(seed));
    //const num = rand_impl.random().int(i32);

    try insert(50);
    try insert(100);
    try insert(25);

    print_list();
    std.debug.print("gtickets : {d}\n", .{gtickets});

    for (0..@intCast(loops)) |_| {
        var counter: i32 = 0;
        const winner: i32 = @mod(rand_impl.random().int(i32), gtickets);

        var current = head;

        while (current != null) {
            counter = counter + current.?.*.tickets;

            if (counter > winner) {
                break;
            }

            current = current.?.*.next;
        }

        print_list();
        std.debug.print("winner: {d} {d}\n\n", .{ winner, current.?.*.tickets });
    }
}
