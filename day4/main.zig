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
    const filename = "./day4/input.txt";

    const allocator = std.heap.page_allocator;

    const txt = try std.fs.cwd().readFileAlloc(allocator, filename, std.math.maxInt(usize));
    defer allocator.free(txt);

    // Create arraylist for each orientation
    var matrix = std.ArrayList(std.ArrayList(u8)).init(allocator);
    defer matrix.deinit();

    // Split the string and iterate through tokens
    var iterator = std.mem.split(u8, txt, "\n");
    while (iterator.next()) |row| {
        var current_row = std.ArrayList(u8).init(allocator);
        for (row) |char| {
            try current_row.append(char);
        }
        try matrix.append(current_row);
    }

    var r: u32 = 0;
    var c: u32 = 0;
    const width: usize = matrix.items.len;
    const height: usize = matrix.items[0].items.len;

    var found: u32 = 0;

    for (matrix.items) |row| {
        for (row.items) |char| {
            if (char == 'X') {

                // East
                if (c + 3 < width) {
                    if ((matrix.items[r].items[c + 1] == 'M') and (matrix.items[r].items[c + 2] == 'A') and (matrix.items[r].items[c + 3] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS E at {d} {d}\n", .{ r, c });
                    }
                }
                // West
                if (c >= 3) {
                    if ((matrix.items[r].items[c - 1] == 'M') and (matrix.items[r].items[c - 2] == 'A') and (matrix.items[r].items[c - 3] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS W at {d} {d}\n", .{ r, c });
                    }
                }
                // South
                if (r + 3 < height) {
                    if ((matrix.items[r + 1].items[c] == 'M') and (matrix.items[r + 2].items[c] == 'A') and (matrix.items[r + 3].items[c] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS S at {d} {d}\n", .{ r, c });
                    }
                }
                // North
                if (r >= 3) {
                    if ((matrix.items[r - 1].items[c] == 'M') and (matrix.items[r - 2].items[c] == 'A') and (matrix.items[r - 3].items[c] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS N at {d} {d}\n", .{ r, c });
                    }
                }
                // SE
                if ((c + 3 < width) and (r + 3 < height)) {
                    if ((matrix.items[r + 1].items[c + 1] == 'M') and (matrix.items[r + 2].items[c + 2] == 'A') and (matrix.items[r + 3].items[c + 3] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS SE at {d} {d}\n", .{ r, c });
                    }
                }
                // SW
                if ((c >= 3) and (r + 3 < height)) {
                    if ((matrix.items[r + 1].items[c - 1] == 'M') and (matrix.items[r + 2].items[c - 2] == 'A') and (matrix.items[r + 3].items[c - 3] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS SW at {d} {d}\n", .{ r, c });
                    }
                }
                // NW
                if ((c >= 3) and (r >= 3)) {
                    if ((matrix.items[r - 1].items[c - 1] == 'M') and (matrix.items[r - 2].items[c - 2] == 'A') and (matrix.items[r - 3].items[c - 3] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS NW at {d} {d}\n", .{ r, c });
                    }
                }
                // NE
                if ((c + 3 < width) and (r >= 3)) {
                    if ((matrix.items[r - 1].items[c + 1] == 'M') and (matrix.items[r - 2].items[c + 2] == 'A') and (matrix.items[r - 3].items[c + 3] == 'S')) {
                        found += 1;
                        //std.debug.print("XMAS NE at {d} {d}\n", .{ r, c });
                    }
                }
            }
            c += 1;
        }
        r += 1;
        c = 0;
    }

    std.debug.print("Found {any}\n", .{found});
    //libaoc.print2dArrayList(matrix, .{ .header = "\n" });

    return;
}

pub fn part2() !void {
    const filename = "./day4/input.txt";

    const allocator = std.heap.page_allocator;

    const txt = try std.fs.cwd().readFileAlloc(allocator, filename, std.math.maxInt(usize));
    defer allocator.free(txt);

    // Create arraylist for each orientation
    var matrix = std.ArrayList(std.ArrayList(u8)).init(allocator);
    defer matrix.deinit();

    // Split the string and iterate through tokens
    var iterator = std.mem.split(u8, txt, "\n");
    while (iterator.next()) |row| {
        var current_row = std.ArrayList(u8).init(allocator);
        for (row) |char| {
            try current_row.append(char);
        }
        try matrix.append(current_row);
    }

    var r: u32 = 0;
    var c: u32 = 0;
    const width: usize = matrix.items.len;
    const height: usize = matrix.items[0].items.len;

    var found: u32 = 0;

    for (matrix.items) |row| {
        for (row.items) |char| {
            if (char == 'A') {
                if ((c >= 1) and (c + 1 < width) and (r >= 1) and (r + 1 < height)) {
                    if (((matrix.items[r - 1].items[c - 1] == 'M') and (matrix.items[r + 1].items[c + 1] == 'S')) or ((matrix.items[r + 1].items[c + 1] == 'M') and (matrix.items[r - 1].items[c - 1] == 'S'))) {
                        if ((matrix.items[r - 1].items[c + 1] == 'M') and (matrix.items[r + 1].items[c - 1] == 'S')) {
                            found += 1;
                            std.debug.print("1 at {d} {d}\n", .{ r, c });
                        } else if ((matrix.items[r + 1].items[c - 1] == 'M') and (matrix.items[r - 1].items[c + 1] == 'S')) {
                            found += 1;
                            std.debug.print("2 at {d} {d}\n", .{ r, c });
                        }
                    } else if (((matrix.items[r - 1].items[c + 1] == 'M') and (matrix.items[r + 1].items[c - 1] == 'S')) or ((matrix.items[r + 1].items[c - 1] == 'M') and (matrix.items[r - 1].items[c + 1] == 'S'))) {
                        if ((matrix.items[r - 1].items[c - 1] == 'M') and (matrix.items[r + 1].items[c + 1] == 'S')) {
                            found += 1;
                            std.debug.print("3 at {d} {d}\n", .{ r, c });
                        } else if ((matrix.items[r + 1].items[c + 1] == 'M') and (matrix.items[r - 1].items[c - 1] == 'S')) {
                            found += 1;
                            std.debug.print("4 at {d} {d}\n", .{ r, c });
                        }
                    }
                }
            }
            c += 1;
        }
        r += 1;
        c = 0;
    }

    std.debug.print("Found {any}\n", .{found});
}
