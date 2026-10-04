const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tinyxml2_dep = b.dependency("tinyxml2", .{});

    const mod = b.addModule("tinyxml2", .{
        .target = target,
        .optimize = optimize,
        .link_libcpp = target.result.abi != .msvc,
        .link_libc = true,
    });
    mod.addIncludePath(tinyxml2_dep.path("."));
    mod.addCSourceFile(.{
        .file = tinyxml2_dep.path("tinyxml2.cpp"),
        .flags = &.{"-std=c++26"},
    });

    const lib = b.addLibrary(.{
        .name = "tinyxml2",
        .root_module = mod,
        .linkage = .static,
    });

    //
    lib.installHeadersDirectory(tinyxml2_dep.path("."), "tinyxml2", .{
        .include_extensions = &.{".h"},
    });

    // This declares intent for the executable to be installed into the
    // install prefix when running `zig build` (i.e. when executing the default
    // step). By default the install prefix is `zig-out/` but can be overridden
    // by passing `--prefix` or `-p`.
    b.installArtifact(lib);
}
