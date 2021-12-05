/// # Advent of Code - Day 1
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const BoundedArray = std.BoundedArray;

const input = @embedFile("./input.txt");

pub fn main() anyerror!void {
    print("Day 1: Sonar sweep!\n", .{});
    print("Part 1: {d}\n", .{part1()});
    print("Part 2: {d}\n", .{part2()});
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

///
/// --- Part Two ---
///
fn part2() !i32 {
    const window_length: usize = 3;
    var increases: i32 = 0;
    var buffer = try BoundedArray(i32, window_length + 1).init(0);
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");

    while (lines.next()) |line| {
        var depth = try std.fmt.parseInt(i32, line, 10);
        try buffer.append(depth);

        if (buffer.len == window_length) {
            // As the sum of middle items are always the same, only the edges need to be compared
            if (depth > buffer.get(0)) {
                increases += 1;
            }
            _ = buffer.orderedRemove(0);
        }
    }

    return increases;
}

test "day01.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1420, comptime try part2());
}
