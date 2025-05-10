const std = @import("std");

pub fn main() !void {
    // Get command line arguments
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    // Check if we have enough arguments
    if (args.len < 2) {
        std.debug.print("Provide a number\n", .{});
        return error.InvalidInput;
    }

    // Parse the argument
    const day_num: u8 = try std.fmt.parseInt(u8, args[1], 10);
    var buf_dir: [64]u8 = undefined;
    var buf_main: [64]u8 = undefined;
    var buf_sample: [64]u8 = undefined;
    var buf_input: [64]u8 = undefined;
    const dirname = try std.fmt.bufPrint(&buf_dir, "day{d}", .{day_num});
    const mainfile = try std.fmt.bufPrint(&buf_main, "day{d}/main.zig", .{day_num});
    const samplefile = try std.fmt.bufPrint(&buf_sample, "day{d}/sample.txt", .{day_num});
    const inputfile = try std.fmt.bufPrint(&buf_input, "day{d}/input.txt", .{day_num});

    const content =
        \\const std = @import("std");
        \\const libaoc = @import("aoc");
        \\
        \\pub fn main() !void {
        \\    const part = try libaoc.parseArgs();
        \\    // Execute the appropriate part
        \\    switch (part) {
        \\        1 => try part1(),
        \\        2 => try part2(),
        \\        else => {
        \\            std.debug.print("Specify part 1 or 2\n", .{});
        \\            return;
        \\        },
        \\    }
        \\}
        \\
        \\pub fn part1() !void {
        \\    std.debug.print("Part 1!\n", .{});
        \\    return;
        \\}
        \\
        \\pub fn part2() !void {
        \\    std.debug.print("Part 2!\n", .{});
        \\    return;
        \\}
    ;

    if (std.fs.cwd().makeDir(dirname)) |_| {
        const file1 = try std.fs.cwd().createFile(mainfile, .{});
        defer file1.close();
        try std.fs.cwd().writeFile(.{
            .sub_path = mainfile,
            .data = content,
        });
        const file2 = try std.fs.cwd().createFile(samplefile, .{});
        defer file2.close();

        const file3 = try std.fs.cwd().createFile(inputfile, .{});
        defer file3.close();
    } else |err| switch (err) {
        error.PathAlreadyExists => {
            // Directory already exists, continue
        },
        else => return err,
    }

    // var buf_url: [64]u8 = undefined;
    // var buf_input: [64]u8 = undefined;
    // const url = try std.fmt.bufPrint(&buf_url, "https://adventofcode.com/2024/day/{d}/input", .{day_num});
    // const input = try std.fmt.bufPrint(&buf_input, "day{d}/input.txt", .{day_num});
    // const argv = [_][]const u8{ "wget", url, "-O", input };

    // var child = std.process.Child.init(&argv, std.heap.page_allocator);
    // const result = try child.spawnAndWait();

    // if (result == .Exited and result.Exited == 0) {
    //     std.debug.print("Download successful\n", .{});
    // } else {
    //     std.debug.print("Download failed\n", .{});
    // }
}
