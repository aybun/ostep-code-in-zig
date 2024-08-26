const std = @import("std");
const common = @import("common.zig")

pub fn main() i32 {

    if (std.os.argv.len != 2) { // Does not work on windows.
        std.log.print("usage: cpu <string>\n");
        std.process.exit(1);
    }
    
    const str = args[1];
    while (true) {
        std.log.print("{s}\n", .{str});
        common.Spin(1);

    }

    return 0;
}
