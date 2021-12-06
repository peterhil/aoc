/// # Advent of Code - Day 3
const std = @import("std");
const math = @import("std").math;

const Allocator = std.mem.Allocator;
const assert = std.debug.assert;
const print = std.debug.print;
const testing = std.testing;

const input = @embedFile("./input.txt");
const bitWidth: u64 = 12;

pub fn main() anyerror!void {
    print("Day 3: Binary Diagnostic\n", .{});
    print("Part 1: {d}\n", .{part1()});
    // print("Part 2: {d}\n", .{part2()});
}

fn getMask() ![bitWidth]u64 {
    var mask = [_]u64{0} ** bitWidth;
    var offset: u5 = 0;

    while (offset < bitWidth) {
        mask[offset] = @as(u64, 1) << offset;
        offset += 1;
    }

    return mask;
}

test "getMask" {
    const expected = [_]u64{
        0b0000_0000_0001,
        0b0000_0000_0010,
        0b0000_0000_0100,
        0b0000_0000_1000,
        0b0000_0001_0000,
        0b0000_0010_0000,
        0b0000_0100_0000,
        0b0000_1000_0000,
        0b0001_0000_0000,
        0b0010_0000_0000,
        0b0100_0000_0000,
        0b1000_0000_0000,
    };
    try testing.expectEqual(getMask(), expected);
}

fn bitArrayToUnsignedInt(bits: [bitWidth]u2) u64 {
    var integer: u64 = 0;

    for (bits) |bit, i| {
        integer = (integer >> 1) + bit * (@as(u64, 1) << @intCast(u5, i));
    }
    return integer;
}

fn part1() !u64 {
    const mask = try getMask();
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    var ones = [1]u64{0} ** bitWidth;
    var bits = [1]u2{0} ** bitWidth;
    var count: u64 = 0;

    while (lines.next()) |line| {
        var bit: u64 = 0;
        var number = try std.fmt.parseInt(u64, line, 2);

        while (bit < bitWidth) {
            if (number & mask[bit] != 0) {
                ones[bit] += 1;
            }
            bit += 1;
        }
        count += 1;
    }

    for (ones) |num, i| {
        var bit: u2 = if (num > (count - num)) 1 else 0;
        bits[i] = bit;
    }

    const gamma: u64 = bitArrayToUnsignedInt(bits);
    const epsilon: u64 = gamma ^ 0x007F;

    // print("lines: {[count]d}\n", .{ .count = count });
    // print("ones: {[ones]d}\n", .{ .ones = ones });
    // print("bits: {[bits]d}\n", .{ .bits = bits });
    // print("gamma: {[gamma]d}\n", .{ .gamma = gamma });
    // print("epsilon: {[epsilon]d}\n", .{ .epsilon = epsilon });

    return gamma * epsilon;
}

test "day02.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(@as(u64, 5014368), comptime try part1());
}
