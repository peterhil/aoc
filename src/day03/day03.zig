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

fn bitArrayToUnsignedInt(bits: []u2) u64 {
    var integer: u64 = 0;
    for (bits) |bit| {
        integer = (integer << 1) + bit;
    }
    return integer;
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
    var total: u64 = numbers.len;
    var bits = try getArraySlice(u2, 0, bitWidth);
    var ones = try getArraySlice(u64, 0, bitWidth);
    var offset: u64 = 0;

    while (offset < bitWidth) {
        var mask = math.pow(u64, 2, bitWidth - offset) / 2;

        for (numbers) |number| {
            if (number & mask != 0) {
                ones[offset] = @as(u64, ones[offset]) + @as(u64, 1);
            }
        }
        offset += 1;
    }

    for (ones) |count, i| {
        var bit: u2 = if (2 * count >= total) 1 else 0;
        bits[i] = bit;
    }

    const gamma: u64 = bitArrayToUnsignedInt(bits);
    const epsilon: u64 = ~gamma & 0xFFF;

    // print("lines: {[total]d}\n", .{ .total = total });
    // print("ones: {[ones]d}\n", .{ .ones = ones });
    // print("bits: {[bits]d}\n", .{ .bits = bits });
    // print("gamma: {[gamma]d}\n", .{ .gamma = gamma });
    // print("epsilon: {[epsilon]d}\n", .{ .epsilon = epsilon });

    return gamma * epsilon;
}

test "day03.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(@as(u64, 3549854), try part1());
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
