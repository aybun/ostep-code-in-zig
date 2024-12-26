const std = @import("std");
const print = std.debug.print;

// Should we pass an allocator to a function?
// What is the right way to do it?
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const PR_STATE_INIT: i32 = 0;

const pr_thread_t = struct {
    Tid: std.Thread,
    State: i32,
};

// Reference on passing function as argument: https://stackoverflow.com/questions/74251650/how-to-pass-zig-function-pointers-to-other-functions
fn PR_CreateThread(comptime start_routine: fn () void) !*pr_thread_t {
    const p: *pr_thread_t = try allocator.create(pr_thread_t);

    p.*.State = PR_STATE_INIT;
    p.*.Tid = try std.Thread.spawn(.{}, start_routine, .{});

    // turn the sleep off to avoid the fault, sometimes...
    std.time.sleep(1 * std.time.ns_per_s);
    return p;
}

fn PR_WaitThread(p: *pr_thread_t) void {
    p.*.Tid.join();
}

var mThread: *pr_thread_t = undefined;
// var mtLock = std.Thread.Mutex{};
// var mtCond = std.Thread.Condition{};
// var mInit: i32 = 0;

fn mMain() void {
    print("mMain: begin\n", .{});

    // mtLock.lock();
    // while (mInit == 0) {
    //     mtCond.wait(&mtLock);
    // }
    // mtLock.unlock();

    //This line will cause a segmanetation fault.
    const mState = mThread.*.State;

    print("mMain: state is {d}\n", .{mState});
}

pub fn main() !void {
    print("ordering: begin\n", .{});
    mThread = try PR_CreateThread(mMain);
    defer allocator.destroy(mThread);

    // mtLock.lock();
    // mInit = 1;
    // mtCond.signal();
    // mtLock.unlock();

    PR_WaitThread(mThread);
    print("ordering: end\n", .{});
}
