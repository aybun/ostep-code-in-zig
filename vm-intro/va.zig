const std = @import("std");

pub fn main() !void {

    // code
    // https://www.reddit.com/r/Zig/comments/1c13bcv/how_to_declare_a_void_pointer_in_zig_ad_how_to/
    // How does it work internally? anyopaque vs void ?
    const mainPtr: *const anyopaque = @ptrCast(&main);
    std.debug.print("location of code : {*}\n", .{mainPtr});

    // heap
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const p: []i64 = try allocator.alloc(i64, 1);
    defer allocator.free(p);

    std.debug.print("location of heap : {*}\n", .{p});

    //stack
    var x: i64 = 3;
    std.debug.print("location of stack : {*}\n", .{&x});

    return;
}
