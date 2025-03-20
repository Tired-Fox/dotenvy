# dotenvy

A layer around Zig's EnvMap that adds variables from a local .env file

# Installation

```
zig fetch --save git+https://github.com/Tired-Fox/dotenvy#{commit,branch,tag}
```

```zig
// build.zig

pub fn build(b: *std.Build) void {
  // ...
  const open = b.dependency("dotenvy", .{}).module("dotenvy")

  const exe_mod = b.createModule(.{
      .root_source_file = b.path("src/main.zig"),
      .target = target,
      .optimize = optimize,
  });

  exe_mode.addImport("dotenvy", open);
}
```

# Usage

```zig
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
```
