// SPDX-License-Identifier: PMPL-1.0-or-later
const std = @import("std");

pub fn build(b: *std.Build) void {
    const modes = .{
        .{ "ReleaseSafe", .ReleaseSafe },
        .{ "ReleaseFast", .ReleaseFast },
    };

    const exports = [_][]const u8{
        "fibonacci", "checked_add", "crash_oob", "crash_unreachable",
        "crash_panic", "crash_overflow", "crash_div_zero", "still_alive",
    };

    inline for (modes) |mode| {
        const name = "safe_nif_" ++ mode[0];
        const exe = b.addExecutable(.{
            .name = name,
            .root_source_file = b.path("src/safe_nif.zig"),
            .target = b.resolveTargetQuery(.{
                .cpu_arch = .wasm32,
                .os_tag = .freestanding,
            }),
            .optimize = mode[1],
        });
        exe.entry = .disabled;
        for (exports) |exp| exe.rdynamic = true;
        _ = exports;
        b.installArtifact(exe);
    }
}
