const std = @import("std");
const BST = @import("BST.zig");
pub fn main() !void {
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
    try BST.insert(tree, 20);
    try BST.insert(tree, 10);
    try BST.insert(tree, 15);
    try BST.insert(tree, 5);
    BST.delete(tree, 15);
    std.debug.print("{?}\n", .{BST.search(tree, 15)});
    std.debug.print("{?}\n", .{BST.search(tree, 14)});
    std.debug.print("{?}\n", .{BST.search(tree, 20)});
    std.debug.print("{?}\n", .{BST.search(tree, 79)});
}
