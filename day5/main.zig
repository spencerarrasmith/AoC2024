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

const PageNode = struct {
    number: u32,
    children: std.ArrayList([]const u32),

    pub fn init(alloc: std.mem.Allocator, num: u32) !PageNode {
        return PageNode{
            .number = num,
            .children = std.ArrayList([]const u32).init(alloc),
        };
    }

    pub fn deinit(self: PageNode) void {
        self.children.deinit();
    }

    pub fn addChild(self: PageNode, rule: []const u8) !void {
        try self.children.append(rule);
    }
};

pub fn part1() !void {
    //const filename = "./day5/sample.txt";

    const allocator = std.heap.page_allocator;

    var test_rule = try PageNode.init(allocator, 8);
    defer test_rule.deinit();

    std.debug.print("{any}\n", .{test_rule.number});
}

pub fn part2() !void {
    std.debug.print("Part 2!\n", .{});
    return;
}
