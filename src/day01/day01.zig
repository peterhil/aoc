/// # Advent of Code - Day 1
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const input = @embedFile("./input.txt");

pub fn main() anyerror!void {
    print("Day 1: Sonar sweep!\n", .{});
    print("Result: {d}\n", .{part1()});
}

///
/// --- Part One ---
///
fn part1() !i32 {
    var increases: i32 = 0;
    var last_depth: i32 = 0xFFFF;
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var depth = try std.fmt.parseInt(i32, line, 10);
        if (depth > last_depth) {
            increases += 1;
        }
        last_depth = depth;
    }
    return increases;
}

test "day01.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1446, comptime try part1());
}
