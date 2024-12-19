// References : https://ziggit.dev/t/read-command-line-arguments/220/7
const std = @import("std");
const assert = @import("std").debug.assert;
const common = @import("common.zig");

pub fn main() !void {
    if (std.os.argv.len != 2) {
        std.debug.print("usage: mem <value>\n", .{});
        std.process.exit(1);
    }

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    // defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const p: []i64 = try allocator.alloc(i64, 1);
    defer allocator.free(p);

    p[0] = try std.fmt.parseInt(i64, args[1], 10);

    const pid = std.os.linux.getpid();
    std.debug.print("({d}) addr pointed to by p: {*}\n", .{ pid, p });

    while (true) {
        common.Spin(1);
        p[0] = p[0] + 1;

        std.debug.print("({d}) value of p: {d}\n", .{ std.os.linux.getpid(), p[0] });
    }

    return;
}
