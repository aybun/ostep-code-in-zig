const std = @import("std");
const common = @import("common.zig");

pub fn main() void {
    if (std.os.argv.len != 2) { // Does not work on windows.
        std.debug.print("usage: cpu <string>\n", .{});
        std.process.exit(1);
    }

    const str = std.os.argv[1];
    while (true) {
        std.debug.print("{s}\n", .{str});
        common.Spin(1);
    }

    return 0;
}
