//Reference :
//https://cookbook.ziglang.cc/04-03-udp-echo.html

const std = @import("std");
const net = std.net;
const posix = std.posix;
const print = std.debug.print;

const BUFFER_SIZE = 1000;

pub fn main() !void {
    // SETUP
    const addr = try net.Address.parseIp("127.0.0.1", 20000);
    const sock = try posix.socket(
        posix.AF.INET,
        posix.SOCK.DGRAM,
        posix.IPPROTO.UDP,
    );
    defer posix.close(sock);

    try posix.bind(sock, &addr.any, addr.getOsSockLen());

    var other_addr = try net.Address.parseIp("127.0.0.1", 10000);
    var other_addrlen: posix.socklen_t = @sizeOf(posix.sockaddr);

    //SENDING MESSAGE
    var buf: [BUFFER_SIZE]u8 = undefined;
    const message = try std.fmt.bufPrint(&buf, "hello world", .{});
    print("client:: send mesaage [{s}]\n", .{message});
    const n_sent = try posix.sendto(
        sock,
        message,
        0,
        &(other_addr.any),
        other_addrlen,
    );
    print("cliet:: sent {d} bytes\n", .{n_sent});

    // RECEIVING MESSAGE
    print("client:: wait for reply...\n", .{});
    const n_recv = try posix.recvfrom(
        sock,
        buf[0..],
        0,
        &(other_addr.any),
        &other_addrlen,
    );

    print("client:: got reply [size:{d} contents:({s})]\n", .{ n_recv, buf[0..n_recv] });
}
