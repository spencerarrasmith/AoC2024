const std = @import("std");

/// Reads a file into an array of bytes
pub fn readFileToArray(filepath: []const u8) !void {
    std.debug.print("Got {s}\n", .{filepath});
}
