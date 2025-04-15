const std = @import("std");

pub fn build(b: *std.Build) void {
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

    // Build day1
    const day1 = b.addExecutable(.{
        .name = "day1",
        .root_source_file = b.path("day1/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    day1.root_module.addImport("aoc", aoc_module);
    day1.linkLibrary(libaoc);
    b.installArtifact(day1);

    // Run commands for each executable
    const run_cmd1 = b.addRunArtifact(day1);
    const run_step1 = b.step("day1", "Run day 1");
    run_step1.dependOn(&run_cmd1.step);
}
