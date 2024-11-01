const std = @import("std");
const print = std.debug.print;
const AtomicOrder: type = std.builtin.AtomicOrder;
const seq_cst = AtomicOrder.seq_cst;

var global: i32 = 0;

pub fn compare_and_swap(ptr: *i32, old: i32, new: i32) bool {
    const success = @cmpxchgStrong(i32, ptr, old, new, seq_cst, seq_cst);

    // if success, the return value from @cmpxchgStrong would be null.
    return success == null;
}

pub fn main() !void {
    var success: bool = false;

    print("before successful cas: {d}\n", .{global});
    success = compare_and_swap(&global, 0, 100);
    print("after successful cas: {d} (success: {})\n", .{ global, success });

    print("before failing cas: {d}\n", .{global});
    success = compare_and_swap(&global, 0, 200);
    print("after failing cas: {d} (old: {})\n", .{ global, success });
}
