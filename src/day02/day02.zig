/// # Advent of Code - Day 2
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const input = @embedFile("./input.txt");

pub fn main() anyerror!void {
    print("Day 2: Dive!\n", .{});
    print("Part 1: {d}\n", .{part1()});
    print("Part 2: {d}\n", .{part2()});
}

const Point = packed struct {
    x: i32 = 0,
    y: i32 = 0,
};

pub fn add(a: Point, b: Point) Point {
    return Point{
        .x = a.x + b.x,
        .y = a.y + b.y,
    };
}

pub fn equals(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

///
/// --- Part One ---
///
fn part1() !i32 {
    var position = Point{ .x = 0, .y = 0 };
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");

    while (lines.next()) |line| {
        var movement: Point = Point{};
        var command = std.mem.split(u8, line, " ");
        var dir = command.next() orelse "";
        var quantity = try std.fmt.parseInt(i32, command.next() orelse "0", 10);

        if (equals(dir, "up")) {
            movement = Point{ .y = -quantity };
        } else if (equals(dir, "down")) {
            movement = Point{ .y = quantity };
        } else if (equals(dir, "forward")) {
            movement = Point{ .x = quantity };
        } else {
            print("Don't know direction: {s}", .{dir});
        }

        position = add(position, movement);
    }
    // print("Distance: {d}m, depth: {d}m\n", .{ position.x, position.y });

    return position.x * position.y;
}

test "day02.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1451208, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    var position = Point{ .x = 0, .y = 0 };
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    var aim: i32 = 0;

    while (lines.next()) |line| {
        var movement: Point = Point{};
        var command = std.mem.split(u8, line, " ");
        var dir = command.next() orelse "";
        var quantity = try std.fmt.parseInt(i32, command.next() orelse "0", 10);

        if (equals(dir, "up")) {
            aim -= quantity;
        } else if (equals(dir, "down")) {
            aim += quantity;
        } else if (equals(dir, "forward")) {
            movement = Point{ .x = quantity, .y = aim * quantity };
        } else {
            print("Don't know direction: {s}", .{dir});
        }

        position = add(position, movement);
    }
    // print("Distance: {d}m, depth: {d}m\n", .{ position.x, position.y });

    return position.x * position.y;
}

test "day02.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1620141160, comptime try part2());
}
