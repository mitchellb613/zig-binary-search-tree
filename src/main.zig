const std = @import("std");
const BST = @import("BST.zig");
const RndGen = std.rand.DefaultPrng;
pub fn main() !void {
    var start_time = std.time.milliTimestamp();
    var rnd = RndGen.init(0);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const tree = try BST.new(&allocator);
    defer {
        BST.free(tree);
        const leaked = gpa.deinit();
        if (leaked) {
            @panic("MEMORY LEAK DETECTED");
        }
    }
    var arr: [10_000]i32 = undefined;
    var count: i32 = 1;
    for (arr) |_, i| {
        arr[i] = count;
        count += 1;
    }
    var i: usize = arr.len - 1;
    while (i > 0) : (i -= 1) {
        var j = rnd.random().intRangeAtMost(usize, 0, i);
        var temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
    for (arr) |item| {
        try BST.insert(tree, item);
    }
    for (arr) |item| {
        _ = BST.search(tree, item);
    }
    for (arr) |item| {
        BST.delete(tree, item);
    }
    var end_time = std.time.milliTimestamp();
    std.debug.print("Time taken: {d}", .{end_time - start_time});
}
