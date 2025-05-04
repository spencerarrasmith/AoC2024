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
    const filename = "./day3/input.txt";

    const allocator = std.heap.page_allocator;

    const txt = try std.fs.cwd().readFileAlloc(allocator, filename, std.math.maxInt(usize));
    defer allocator.free(txt);

    //std.debug.print("{s}\n", .{txt});
    var total: i32 = 0;

    for (txt, 0..) |_, i| {
        if (std.mem.startsWith(u8, txt[i..], "mul(")) {
            const num_start = i + 4;

            // Find first number
            var num1_end = num_start;
            while (num1_end < txt.len and std.ascii.isDigit(txt[num1_end])) {
                num1_end += 1;
            }

            // Check for comma
            if (num1_end < txt.len and txt[num1_end] == ',') {
                const num2_start = num1_end + 1;
                var num2_end = num2_start;

                // Find second number
                while (num2_end < txt.len and std.ascii.isDigit(txt[num2_end])) {
                    num2_end += 1;
                }

                // Check for closing parenthesis
                if (num2_end < txt.len and txt[num2_end] == ')') {
                    const num1 = txt[num_start..num1_end];
                    const num2 = txt[num2_start..num2_end];
                    const v1 = try std.fmt.parseInt(i32, num1, 10);
                    const v2 = try std.fmt.parseInt(i32, num2, 10);
                    total += v1 * v2;
                }
            }
        }
    }

    std.debug.print("{d}\n", .{total});
}

pub fn part2() !void {
    const filename = "./day3/input.txt";

    const allocator = std.heap.page_allocator;

    const txt = try std.fs.cwd().readFileAlloc(allocator, filename, std.math.maxInt(usize));
    defer allocator.free(txt);

    var total: i32 = 0;
    var do: bool = true;

    for (txt, 0..) |_, i| {
        if (std.mem.startsWith(u8, txt[i..], "don't()")) {
            do = false;
        } else if (std.mem.startsWith(u8, txt[i..], "do()")) {
            do = true;
        } else if (std.mem.startsWith(u8, txt[i..], "mul(")) {
            const num_start = i + 4;

            // Find first number
            var num1_end = num_start;
            while (num1_end < txt.len and std.ascii.isDigit(txt[num1_end])) {
                num1_end += 1;
            }

            // Check for comma
            if (num1_end < txt.len and txt[num1_end] == ',') {
                const num2_start = num1_end + 1;
                var num2_end = num2_start;

                // Find second number
                while (num2_end < txt.len and std.ascii.isDigit(txt[num2_end])) {
                    num2_end += 1;
                }

                // Check for closing parenthesis
                if (num2_end < txt.len and txt[num2_end] == ')') {
                    const num1 = txt[num_start..num1_end];
                    const num2 = txt[num2_start..num2_end];
                    const v1 = try std.fmt.parseInt(i32, num1, 10);
                    const v2 = try std.fmt.parseInt(i32, num2, 10);
                    if (do) {
                        total += v1 * v2;
                    }
                }
            }
        }
    }
    std.debug.print("{d}\n", .{total});
}
