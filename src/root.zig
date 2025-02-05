const std = @import("std");
const testing = std.testing;

pub const Event = struct {
    id: []u8,
    kind: i64 = 0,
    created_at: i64,
    pubkey: []u8,
    content: []u8,
    sig: []u8,
    tags: [][][]u8,
};
