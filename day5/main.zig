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
    children: std.ArrayList(u32),

    pub fn init(alloc: std.mem.Allocator, num: u32) !PageNode {
        return PageNode{
            .number = num,
            .children = std.ArrayList(u32).init(alloc),
        };
    }

    pub fn deinit(self: PageNode) void {
        self.children.deinit();
    }

    pub fn addChild(self: *PageNode, rule: u32) !void {
        try self.children.append(rule);
    }
};

pub fn part1() !void {
    const filename = "./day5/input.txt";

    const allocator = std.heap.page_allocator;

    const txt = try std.fs.cwd().readFileAlloc(allocator, filename, std.math.maxInt(usize));
    defer allocator.free(txt);

    // Create map to easily access PageNodes
    var pageRules = std.AutoHashMap(u32, PageNode).init(allocator);
    defer pageRules.deinit();

    var manuals = std.ArrayList(std.ArrayList(u32)).init(allocator);

    var iterator = std.mem.split(u8, txt, "\n");
    while (iterator.next()) |row| {
        if (std.mem.indexOfScalar(u8, row, '|')) |index| {
            // This is a rule
            const page: u32 = try std.fmt.parseInt(u32, row[0..index], 10);
            const child: u32 = try std.fmt.parseInt(u32, row[(index + 1)..(row.len - 1)], 10);

            if (pageRules.getPtr(page)) |node| {
                try node.addChild(child);
            } else {
                var node = try PageNode.init(allocator, page);
                try node.addChild(child);
                try pageRules.put(page, node);
            }
        } else if (std.mem.indexOfScalar(u8, row, ',')) |_| {
            // This is a print ordering
            var manIter = std.mem.split(u8, row, ",");
            var manual = std.ArrayList(u32).init(allocator);

            while (manIter.next()) |page| {
                const trimmed = std.mem.trim(u8, page, " \t\n\r");
                const pageInt: u32 = try std.fmt.parseInt(u32, trimmed, 10);
                try manual.append(pageInt);
            }
            try manuals.append(manual);
        } else {
            // Empty line separating rules from manuals, most likely. Ignore these lines
            continue;
        }
    }

    var middlePageSum: u32 = 0;

    // Validate manuals
    for (manuals.items) |manual| {
        var valid: bool = true;
        var currentNode: PageNode = try PageNode.init(allocator, 0);
        var currentIndex: usize = 0;

        if (pageRules.get(manual.items[currentIndex])) |node| {
            currentNode = node;
        }

        while ((valid == true) and (currentIndex < (manual.items.len - 1))) {
            currentIndex = currentIndex + 1;
            var found: bool = false;
            var foundChild: u32 = 0;
            for (currentNode.children.items) |child| {
                if (manual.items[currentIndex] == child) {
                    found = true;
                    foundChild = child;
                }
            }
            if (found) {
                std.debug.print("{any} has {any}\n", .{ currentNode.number, foundChild });
                if (pageRules.get(manual.items[currentIndex])) |newNode| {
                    currentNode = newNode;
                    std.debug.print("New node {any}\n", .{currentNode.number});
                } else {
                    if (currentIndex != manual.items.len - 1) {
                        valid = false;
                    }
                }
            } else {
                valid = false;
            }
        }
        if (valid) {
            std.debug.print("GOOD {any}\n", .{manual.items[(manual.items.len - 1) / 2]});
            middlePageSum = middlePageSum + manual.items[(manual.items.len - 1) / 2];
        } else {
            std.debug.print("BAD\n", .{});
        }
    }

    std.debug.print("\n{any}\n", .{middlePageSum});

    // if (pageRules.get(47)) |node| {
    //     libaoc.printArrayList(node.children, .{});
    // }

    // libaoc.printArrayList(manuals.items[0], .{});

    //std.debug.print("{any}\n", .{rulesArray[0].number});
}

pub fn part2() !void {
    std.debug.print("Part 2!\n", .{});
    return;
}
