const std = @import("std");

pub const Mutex = std.Mutex;
pub const CondVar = std.ConditionVariable;
pub const Semaphore = std.Semaphore;

//Mostly translated by perplexity.ai
pub fn createThread(
    thread: *std.Thread,
    start_routine: fn (*anyopaque) void,
    arg: *anyopaque,
) !void {
    const result = std.Thread.create(thread, null, start_routine, arg);
    if (result != 0) {
        std.debug.assert(false, "Failed to create thread");
    }
}

pub fn joinThread(thread: *std.Thread) !void {
    const result = std.Thread.join(thread);
    if (result != 0) {
        std.debug.assert(false, "Failed to join thread");
    }
}

// Mutex functions
pub fn mutexInit(m: *Mutex) !void {
    const result = m.init();
    if (result != 0) {
        std.debug.assert(false, "Failed to initialize mutex");
    }
}

pub fn mutexLock(m: *Mutex) !void {
    const result = m.lock();
    if (result != 0) {
        std.debug.assert(false, "Failed to lock mutex");
    }
}

pub fn mutexUnlock(m: *Mutex) !void {
    const result = m.unlock();
    if (result != 0) {
        std.debug.assert(false, "Failed to unlock mutex");
    }
}

// Condition variable functions
pub fn condInit(cond: *CondVar) !void {
    const result = cond.init();
    if (result != 0) {
        std.debug.assert(false, "Failed to initialize condition variable");
    }
}

pub fn condSignal(cond: *CondVar) !void {
    const result = cond.signal();
    if (result != 0) {
        std.debug.assert(false, "Failed to signal condition variable");
    }
}

pub fn condWait(cond: *CondVar, m: *Mutex) !void {
    const result = cond.wait(m);
    if (result != 0) {
        std.debug.assert(false, "Failed to wait on condition variable");
    }
}

// Semaphore functions (only available on Linux)
// if (@compileTimeTarget().os == .linux){

pub fn semInit(sem: *Semaphore, value: u32) !void {
    const result = sem.init(value);
    if (result != 0) {
        std.debug.assert(false, "Failed to initialize semaphore");
    }
}

pub fn semWait(sem: *Semaphore) !void {
    const result = sem.wait();
    if (result != 0) {
        std.debug.assert(false, "Failed to wait on semaphore");
    }
}

pub fn semPost(sem: *Semaphore) !void {
    const result = sem.post();
    if (result != 0) {
        std.debug.assert(false, "Failed to post semaphore");
    }
}
