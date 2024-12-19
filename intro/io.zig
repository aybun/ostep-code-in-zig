const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    // defer _ = gpa.deinit();

    var fd = try std.fs.cwd().createFile("/tmp/file", .{});
    defer fd.close();

    const buffer = try allocator.alloc(u8, 20);
    defer allocator.free(buffer);

    _ = try std.fmt.bufPrint(buffer, "hello world\n", .{});

    _ = try fd.writeAll(buffer);
}
