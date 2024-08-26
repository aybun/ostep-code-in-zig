// References : https://ziggit.dev/t/read-command-line-arguments/220/7
//
const std = @import("std");
const assert = @import("std").debug.assert;

const common = @import("common.zig");

pub fn main() !i32 {
    if (std.os.argv.len != 2) {
        std.log.print("usage: mem <value>\n");
        std.process.exit(1);
    }

    var str = std.os.argv[1];
    
    //Allocator : https://zig.guide/standard-library/allocators/
    // What's a Memory Allocator Anyway? - Benjamin Feng : https://www.youtube.com/watch?v=vHWiDx_l4V0
    var buffer: [1]i32 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var p = try allocator.alloc(i32, 1);
    defer allocator.destroy(p);
    
    // Process id
    const pid = std.os.getpid();
    std.log.print("({d}) addr pointed to by p: {*}\n", .{ pid, p });
    

    //base 10
    p.* = try std.fmt.parseInt(i32, std.os.argv[1], 10);
    
    while(true){

        common.Spin(1);
        p.* = p.* + 1;

        std.log.print("({d}) value of p: {d}\n", .{std.os.getpid(), p.*});
    } 

    return 0;
}

