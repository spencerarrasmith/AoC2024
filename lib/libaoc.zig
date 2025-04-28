const std = @import("std");

/// Reads a file into an array of bytes
pub fn readFileToArray(filepath: []const u8) !void {
    std.debug.print("Got {s}\n", .{filepath});
}

pub fn parseArgs() !u8 {
    // Get command line arguments
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    // Check if we have enough arguments
    if (args.len < 2) {
        std.debug.print("Specify part 1 or 2\n", .{});
        return error.InvalidInput;
    }

    // Parse the part number
    const part: u8 = try std.fmt.parseInt(u8, args[1], 10);
    return part;
}
