//Reference :
//https://cookbook.ziglang.cc/04-03-udp-echo.html

const std = @import("std");
const net = std.net;
const posix = std.posix;
const print = std.debug.print;

const BUFFER_SIZE = 1000;

pub fn main() !void {
    // adjust the ip/port here as needed
    const addr = try net.Address.parseIp("127.0.0.1", 10000);

    // get a socket and set domain, type and protocol flags
    const sock = try posix.socket(
        posix.AF.INET,
        posix.SOCK.DGRAM,
        posix.IPPROTO.UDP,
    );

    // for completeness, we defer closing the socket. In practice, if this is
    // a one-shot program, we could omit this and let the OS do the cleanup
    defer posix.close(sock);

    try posix.bind(sock, &addr.any, addr.getOsSockLen());

    var other_addr: posix.sockaddr = undefined;
    var other_addrlen: posix.socklen_t = @sizeOf(posix.sockaddr);

    var buf: [BUFFER_SIZE]u8 = undefined;

    print("server:: waiting... {any}...\n", .{addr});

    // we did not set the NONBLOCK flag (socket type flag),
    // so the program will wait until data is received

    while (true) {
        const n_recv = try posix.recvfrom(
            sock,
            buf[0..],
            0,
            &other_addr,
            &other_addrlen,
        );
        // print(
        //     "received {d} byte(s) from {any};\n    string: {s}\n",
        //     .{ n_recv, other_addr, buf[0..n_recv] },
        // );
        print("server:: read message [size:{d} contents:({s})]\n", .{ n_recv, buf[0..n_recv] });

        // we could extract the source address of the received data by
        // parsing the other_addr.data field

        //https://ziggit.dev/t/what-is-zig-analog-for-c-sprintf/360
        var reply_buf: [BUFFER_SIZE]u8 = undefined;
        const written_reply_buf = try std.fmt.bufPrint(&reply_buf, "goodbye world", .{});

        const n_sent = try posix.sendto(
            sock,
            written_reply_buf, // buf[0..n_recv],
            0,
            &other_addr,
            other_addrlen,
        );
        print("server:: reply {d} bytes back\n", .{n_sent});
    }
}
