const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    //const alloc = arena.allocator();
    //std.log.info("cwd: {s}", .{
    //    try std.fs.cwd().realpathAlloc(alloc, "."),
    //});

    const filename = "./day1/input.txt";

    var buffer: [65536]u8 = undefined;
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const bytes_read = try file.readAll(&buffer);
    if (bytes_read == 0) {
        return;
    }
    //std.debug.print("{d}\n", .{bytes_read});

    // Split by multiple delimiters
    var i: usize = 0;
    var iterator = std.mem.tokenize(u8, buffer[0..bytes_read], " \n");

    // Declare dynamic lists for storing location IDs
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var list1 = std.ArrayList(i32).init(allocator);
    defer list1.deinit();

    var list2 = std.ArrayList(i32).init(allocator);
    defer list2.deinit();

    // Populate lists
    while (i < bytes_read) : (i += 1) {
        const token = iterator.next() orelse break;
        //std.debug.print("[{}]: {s}\n", .{ i, token });
        const num: i32 = try std.fmt.parseInt(i32, token, 10);
        if (i % 2 == 0) {
            try list1.append(num);
        } else {
            try list2.append(num);
        }
    }

    // Sort lists in ascending order
    std.sort.block(i32, list1.items, {}, std.sort.asc(i32));
    //std.debug.print("List1: {any}\n", .{list1.items});

    std.sort.block(i32, list2.items, {}, std.sort.asc(i32));
    //std.debug.print("List2: {any}\n", .{list2.items});

    var diff: u32 = 0;

    for (0..list1.items.len) |j| {
        diff += @abs(list1.items[j] - list2.items[j]);
    }

    std.debug.print("Diff: {any}\n", .{diff});
}
