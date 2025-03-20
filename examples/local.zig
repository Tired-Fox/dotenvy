const std = @import("std");
const dotenvy = @import("dotenvy");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    defer _ = gpa.deinit();

    var env_map = try dotenvy.parse(gpa.allocator(), null);
    defer env_map.deinit();

    if (env_map.get("MESSAGE")) |message| {
        std.debug.print("{s}\n", .{message});
    } else {
        std.debug.print("No Message\n", .{});
    }
}
