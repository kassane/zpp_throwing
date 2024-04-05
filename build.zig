//! zig 0.11.0 & 0.12.0 - LLVM 17 (libc++ + libunwind)
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zpp_example",
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(.{ .path = "." });
    exe.addCSourceFile(.{
        .file = .{ .cwd_relative = "zpp.cc" },
        .flags = &.{
            "-Wall",
            "-Wpedantic",
            "-Wextra",
            "-std=c++23",
            "-fno-exceptions",
            "-fno-rtti",
            "-fno-threadsafe-statics",
            "-fno-unwind-tables",
        },
    });
    exe.linkLibCpp();
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", b.fmt("Run the {s} app", .{exe.name}));
    run_step.dependOn(&run_cmd.step);
}
