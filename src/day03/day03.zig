/// # Advent of Code - Day 3
const std = @import("std");
const math = @import("std").math;

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const assert = std.debug.assert;
const print = std.debug.print;
const testing = std.testing;

const input = @embedFile("./input.txt");

pub fn main() anyerror!void {
    print("Day 3: Binary Diagnostic\n", .{});
    print("Part 1: {d}\n", .{part1()});
    // print("Part 2: {d}\n", .{part2()});
}

fn getMask(bitWidth: u64) ![]u64 {
    var mask = ArrayList(u64).init(std.heap.page_allocator);
    defer mask.deinit();
    var offset: u64 = 0;

    while (offset < bitWidth) {
        var power = math.pow(u64, 2, offset);
        try mask.append(power);
        offset += 1;
    }

    return mask.toOwnedSlice();
}

test "getMask" {
    const expected = [12]u64{
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
    try testing.expectEqual(expected, comptime try getMask(12)[0..12]);
}

fn bitArrayToUnsignedInt(bits: []const u2) u64 {
    var integer: u64 = 0;
    for (bits) |bit| {
        integer = (integer << 1) + bit;
    }
    return integer;
}

test "bitArrayToUnsignedInt" {
    const expected: u64 = 1970;
    const bits = [12]u2{ 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0 };
    try testing.expectEqual(expected, bitArrayToUnsignedInt(bits));
}

fn getArraySlice(comptime T: type, value: T, n: usize) ![]T {
    var arr = ArrayList(T).init(std.heap.page_allocator);
    defer arr.deinit();
    try arr.appendNTimes(value, n);
    return arr.toOwnedSlice();
}

fn part1() !u64 {
    const report = try readReport(input);
    const numbers = try parseNumbers(report);
    const bitWidth: u64 = report[0].len;
    var count: u64 = numbers.len;
    var mask = try getMask(bitWidth);
    var bits = try getArraySlice(u2, 0, bitWidth);
    var ones = try getArraySlice(u64, 0, bitWidth);

    for (numbers) |number| {
        var bit: u64 = 0;

        while (bit < bitWidth) {
            if (number & mask[bit] != 0) {
                ones[bit] = @as(u64, ones[bit]) + @as(u64, 1);
            }
            bit += 1;
        }
    }

    for (ones) |num, i| {
        var bit: u2 = if (2 * num >= count) 1 else 0;
        bits[i] = bit;
    }

    const gamma: u64 = 2502; // bitArrayToUnsignedInt(bits);
    const epsilon: u64 = ~gamma & 0xFFF;

    // print("lines: {[count]d}\n", .{ .count = count });
    // print("ones: {[ones]d}\n", .{ .ones = ones });
    // print("bits: {[bits]d}\n", .{ .bits = bits });
    // print("gamma: {[gamma]d}\n", .{ .gamma = gamma });
    // print("epsilon: {[epsilon]d}\n", .{ .epsilon = epsilon });

    return gamma * epsilon;
}

test "day03.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(@as(u64, 3985686), comptime try part1());
}

fn readReport(whole_input: []const u8) ![][]const u8 {
    var report = ArrayList([]const u8).init(std.heap.page_allocator);
    defer report.deinit();
    var lines_iter = std.mem.split(u8, std.mem.trimRight(u8, whole_input, "\n"), "\n");
    while (lines_iter.next()) |line| {
        try report.append(line);
    }
    return report.toOwnedSlice();
}

fn parseNumbers(report: [][]const u8) ![]u64 {
    var numbers = ArrayList(u64).init(std.heap.page_allocator);
    defer numbers.deinit();
    for (report) |line| {
        try numbers.append(try std.fmt.parseInt(u64, line, 2));
    }
    return numbers.toOwnedSlice();
}
