const std = @import("std");
const libaoc = @import("aoc");

pub fn main() !void {
    const part = try libaoc.parseArgs();
    // Execute the appropriate part
    switch (part) {
        1 => try part1(),
        2 => try part2(),
        else => {
            std.debug.print("Specify part 1 or 2\n", .{});
            return;
        },
    }
}

pub fn part1() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const filename = "./day2/input.txt";

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
    defer {
        // First deinitialize each inner ArrayList
        for (data.items) |*report| {
            report.deinit();
        }
        // Then deinitialize the outer ArrayList
        data.deinit();
    }

    while (iterator.next()) |report| {
        var current_report = std.ArrayList(i32).init(allocator);
        var iter_report = std.mem.tokenize(u8, report, " ");
        while (iter_report.next()) |level| {
            const level_int: i32 = try std.fmt.parseInt(i32, level, 10);
            try current_report.append(level_int);
        }
        try data.append(current_report);
    }

    var count_safe: i32 = 0;
    // std.debug.print("\nData:\n", .{});
    for (data.items) |report| {
        //for (report.items) |level| {
        //    std.debug.print("{d} ", .{level});
        //}
        const inc: bool = try verify_increasing(report);
        const dec: bool = try verify_decreasing(report);
        //std.debug.print("{any} {any}\n", .{ inc, dec });
        if (inc or dec) {
            count_safe += 1;
        }
    }
    std.debug.print("{any}\n", .{count_safe});
}

pub fn verify_increasing(report: std.ArrayList(i32)) !bool {
    var current_level: i32 = report.items[0];
    for (report.items[1..]) |level| {
        if ((level > current_level) and ((level - current_level) <= 3)) {
            current_level = level;
        } else {
            return false;
        }
    }
    return true;
}

pub fn verify_decreasing(report: std.ArrayList(i32)) !bool {
    var current_level: i32 = report.items[0];
    for (report.items[1..]) |level| {
        if ((level < current_level) and ((current_level - level) <= 3)) {
            current_level = level;
        } else {
            return false;
        }
    }
    return true;
}

pub fn part2() !void {
    std.debug.print("Wow!", .{});
}
