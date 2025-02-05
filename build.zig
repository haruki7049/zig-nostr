const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // zig-nostr Zig Module
    _ = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // zig-nostr Static library
    const lightmix = b.addStaticLibrary(.{
        .root_source_file = b.path("src/root.zig"),
        .name = "zig-nostr",
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lightmix);

    // Unit tests
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Docs
    const docs_step = b.step("docs", "Install documents into zig-out/share/docs");
    const docs_install = b.addInstallDirectory(.{
        .source_dir = lightmix.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "share/docs",
    });
    docs_step.dependOn(&docs_install.step);
}
