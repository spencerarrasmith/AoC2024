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
    std.debug.print("Part 1!\n", .{});
    return;
}

pub fn part2() !void {
    std.debug.print("Part 2!\n", .{});
    return;
}