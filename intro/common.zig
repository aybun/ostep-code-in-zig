const std = @import("std");

//time in seconds
//https://github.com/ziglang/zig/blob/master/lib/std/time.zig
pub fn GetTime() f64 {
    const now = std.time.timestamp();
    return @as(f64, @floatFromInt(now));
}

pub fn Spin(howlong: i64) void {
    const start = GetTime();

    while ((GetTime() - start) < @as(f64, @floatFromInt(howlong))) {
        //Do nothing
    }
}
