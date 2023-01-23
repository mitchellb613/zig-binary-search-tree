const std = @import("std");

const Allocator = std.mem.Allocator;

const Node = struct {
    value: i32,
    left: ?*Node,
    right: ?*Node,
};

fn Node_new(allocator: *const Allocator, value: i32) !*Node {
    const node = try allocator.create(Node);
    node.* = .{ .value = value, .left = null, .right = null };
    return node;
}

const BST = struct {
    root: ?*Node,
    allocator: *const Allocator,
};

pub fn new(allocator: *const Allocator) !*BST {
    const bst = try allocator.create(BST);
    bst.* = .{ .root = null, .allocator = allocator };
    return bst;
}

pub fn insert(bst: *BST, value: i32) !void {
    var optional_trail: ?*Node = null;
    var optional_lead: ?*Node = bst.root;
    while (optional_lead) |lead| {
        optional_trail = lead;
        if (value <= lead.value) {
            optional_lead = lead.left;
        } else {
            optional_lead = lead.right;
        }
    }
    if (optional_trail) |trail| {
        if (value <= trail.value) {
            trail.left = try Node_new(bst.allocator, value);
        } else {
            trail.right = try Node_new(bst.allocator, value);
        }
    } else {
        bst.root = try Node_new(bst.allocator, value);
    }
}

pub fn search(bst: *const BST, value: i32) bool {
    var optional_node = bst.root;
    while (optional_node) |current_node| {
        if (value < current_node.value) {
            optional_node = current_node.left;
        } else if (value > current_node.value) {
            optional_node = current_node.right;
        } else {
            return true;
        }
    }
    return false;
}

pub fn free(bst: *const BST) void {
    free_helper(bst.allocator, bst.root);
    bst.allocator.destroy(bst);
}

fn free_helper(allocator: *const Allocator, optional_node: ?*const Node) void {
    if (optional_node) |node| {
        free_helper(allocator, node.left);
        free_helper(allocator, node.right);
        allocator.destroy(node);
    }
}
