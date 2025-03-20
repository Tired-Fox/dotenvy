const std = @import("std");

/// Snapshot of the current process's environment variables.
/// 
/// Additional variables are loaded from a `.env` file or custom file path.
pub fn parse(allocator: std.mem.Allocator, path: ?[]const u8) !std.process.EnvMap {
    var env_vars = try std.process.getEnvMap(allocator);

    var file = std.fs.cwd().openFile(path orelse ".env", .{}) catch return env_vars;
    defer file.close();

    var buff_reader = std.io.bufferedReader(file.reader());
    var stream = buff_reader.reader();

    while (true) {
        const line = try stream.readUntilDelimiterOrEofAlloc(allocator, '\n', 1024 * 1024);
        defer if (line) |l| allocator.free(l);

        if (line == null or line.?.len == 0) break;

        if (std.mem.containsAtLeast(u8, line.?, 1, "=")) {
            var iter = std.mem.splitSequence(u8, line.?, "=");
            const key = iter.next().?;
            const value = std.mem.trimRight(u8, line.?[key.len+1..], &std.ascii.whitespace);

            try env_vars.put(
                key,
                if (std.mem.startsWith(u8, value, "\""))
                    std.mem.trim(u8, value, "\"")
                else if (std.mem.startsWith(u8, value, "'"))
                    std.mem.trim(u8, value, "'")
                else
                    value
            );
        }
    }

    return env_vars;
}
