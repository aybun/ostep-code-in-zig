const std = @import("std");
const time = std.time;
const assert = std.debug.assert;

pub fn GetTime() f64 {
    const now = time.microTime();
    return @as(f64, @floatFromInt(now)) / 1_000_000;
}

pub fn Spin(howlong: i32) void {
    const start = time.getTime();

    while (time.getTime() - start < @as(f64, @floatFromInt(howlong))) {
        //Do nothing
    }
}
