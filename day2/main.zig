const std = @import("std");
const libaoc = @import("aoc");

pub fn main() !void {
    try part1();
    //try part2();
}

pub fn part1() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const filename = "./day2/sample.txt";

    var buffer: [65536]u8 = undefined;
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const bytes_read = try file.readAll(&buffer);
    if (bytes_read == 0) {
        return;
    }

    // Split by newlines
    var iterator = std.mem.tokenize(u8, buffer[0..bytes_read], "\n");

    // Declare dynamic lists for storing location IDs
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    var data = std.ArrayList(std.ArrayList(i32)).init(allocator);
    defer data.deinit();

    while (iterator.next()) |report| {
        var iter_report = std.mem.tokenize(u8, report, " ");
        while (iter_report.next()) |level| {
            std.debug.print("{s}\n", .{level});
        }
    }
}

pub fn part2() !void {}
