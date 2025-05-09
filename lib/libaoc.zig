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

// TODO make axes labels be row/column indices instead of text
pub fn printArrayList(
    list: anytype,
    options: struct {
        header: ?[]const u8 = null,
        show_index: bool = true,
        show_hex: bool = false,
        show_char: bool = true,
        separator: []const u8 = "\n",
        max_items: ?usize = null,
    },
) void {
    const T = @TypeOf(list.items[0]);
    const is_byte_type = T == u8;

    // Print header if provided
    if (options.header) |header| {
        std.debug.print("{s} (size: {d}){s}", .{ header, list.items.len, options.separator });
    }

    // Calculate how many items to print
    const item_count = if (options.max_items) |max|
        @min(max, list.items.len)
    else
        list.items.len;

    // Print each item
    for (list.items[0..item_count], 0..) |item, i| {
        // Start with index if requested
        if (options.show_index) {
            std.debug.print("{any}: ", .{i});
        }

        // Print the item value
        std.debug.print("{any}", .{item});

        // For byte types, show additional representations
        if (is_byte_type) {
            if (options.show_char) {
                const char: u8 = @intCast(item);
                // Only print as character if it's printable
                if (std.ascii.isPrint(char)) {
                    std.debug.print(" '{c}'", .{char});
                } else {
                    std.debug.print(" (non-printable)", .{});
                }
            }

            if (options.show_hex) {
                std.debug.print(" 0x{x}", .{item});
            }
        }

        std.debug.print("{s}", .{options.separator});
    }

    // Show truncation message
    if (item_count < list.items.len) {
        std.debug.print("... ({d} more items)\n", .{list.items.len - item_count});
    }
}

pub fn print2dArrayList(
    list2d: anytype,
    options: struct {
        header: ?[]const u8 = null,
        row_prefix: []const u8 = "",
        show_row_index: bool = false,
        show_col_index: bool = false,
        show_hex: bool = false,
        show_char: bool = true,
        row_separator: []const u8 = "\n",
        col_separator: []const u8 = " ",
        max_rows: ?usize = null,
        max_cols: ?usize = null,
        indent: []const u8 = "  ",
    },
) void {
    // Print header if provided
    if (options.header) |header| {
        std.debug.print("{s} ({d} rows){s}", .{ header, list2d.items.len, options.row_separator });
    }

    // Calculate how many rows to print
    const row_count = if (options.max_rows) |max|
        @min(max, list2d.items.len)
    else
        list2d.items.len;

    // Print each row
    for (list2d.items[0..row_count], 0..) |row, row_idx| {
        // Print row header
        if (options.show_row_index) {
            std.debug.print("{s}{d}: ", .{ options.row_prefix, row_idx });
        }

        // Use printArrayList for the contents of this row
        printArrayList(row, .{
            .header = null,
            .show_index = options.show_col_index,
            .show_hex = options.show_hex,
            .show_char = options.show_char,
            .separator = options.col_separator,
            .max_items = options.max_cols,
        });

        std.debug.print("{s}", .{options.row_separator});
    }

    // Show truncation message for rows
    if (row_count < list2d.items.len) {
        std.debug.print("... ({d} more rows)\n", .{list2d.items.len - row_count});
    }
}
