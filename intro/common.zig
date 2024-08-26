

const std = @import("std");
const time = std.time;
const assert = std.debug.assert;

pub fn GetTime() f64{

    const now = time.microTime();
    return @intToFloat(64, now) / 1_000_000;

}

pub fn Spin(howlong: i32) void {
    const start = getTime();

    while(getTime() - start < @intToFloat(f64, howlong)){
    //Do nothing
    }
}

