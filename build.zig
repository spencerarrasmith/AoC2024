const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create a module for the shared library
    const libaoc = b.addStaticLibrary(.{
        .name = "aoc",
        .root_source_file = b.path("lib/libaoc.zig"),
        .target = target,
        .optimize = optimize,
    });
    //libaoc.addIncludePath(b.path("lib/"));
    b.installArtifact(libaoc);

    // Create a module for the library
    const aoc_module = b.addModule("aoc", .{
        .root_source_file = b.path("lib/libaoc.zig"),
        .imports = &.{},
    });

    // Build day builder
    const daybuilder = b.addExecutable(.{
        .name = "create_day",
        .root_source_file = b.path("create_day.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(daybuilder);

    // ArrayList of strings (slices)
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    var day_dirs = std.ArrayList([]const u8).init(allocator);
    defer {
        // Free each string in the list
        for (day_dirs.items) |item| {
            allocator.free(item);
        }
        day_dirs.deinit();
    }

    // Open current directory
    var dir = std.fs.cwd().openDir(".", .{ .iterate = true }) catch |err| {
        std.debug.print("Could not open directory: {}\n", .{err});
        return;
    };
    defer dir.close();
    // Iterate through directory entries
    var iterator = dir.iterate();
    while (try iterator.next()) |entry| {
        if (entry.kind == .directory) {
            // Check if name starts with "day" followed by digits
            if (std.mem.startsWith(u8, entry.name, "day")) {
                // Verify rest of string is all digits
                var valid = true;
                for (entry.name[3..]) |c| {
                    if (!std.ascii.isDigit(c)) {
                        valid = false;
                        break;
                    }
                }

                if (valid) {
                    // Make a copy of the name (iterator reuses memory)
                    const name_copy = try allocator.dupe(u8, entry.name);
                    try day_dirs.append(name_copy);
                }
            }
        }
    }

    var buf_name: [64]u8 = undefined;
    var buf_file: [64]u8 = undefined;
    for (day_dirs.items) |day_num| {
        // Build day
        const name = try std.fmt.bufPrint(&buf_name, "{s}", .{day_num});
        const filename = try std.fmt.bufPrint(&buf_file, "{s}/main.zig", .{day_num});

        const day = b.addExecutable(.{
            .name = name,
            .root_source_file = b.path(filename),
            .target = target,
            .optimize = optimize,
        });
        day.root_module.addImport("aoc", aoc_module);
        day.linkLibrary(libaoc);
        b.installArtifact(day);
    }

    // // Build day1
    // const day1 = b.addExecutable(.{
    //     .name = "day1",
    //     .root_source_file = b.path("day1/main.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });
    // day1.root_module.addImport("aoc", aoc_module);
    // day1.linkLibrary(libaoc);
    // b.installArtifact(day1);

    // // Build day2
    // const day2 = b.addExecutable(.{
    //     .name = "day2",
    //     .root_source_file = b.path("day2/main.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });
    // day2.root_module.addImport("aoc", aoc_module);
    // day2.linkLibrary(libaoc);
    // b.installArtifact(day2);

    // Run commands for each executable
    // const run_cmd1 = b.addRunArtifact(day1);
    // const run_step1 = b.step("day1", "Run day 1");
    // run_step1.dependOn(&run_cmd1.step);
}
