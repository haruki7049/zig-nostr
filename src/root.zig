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

const Filter = struct {
    ids: std.ArrayList([]const u8) = undefined,
    authors: std.ArrayList([]const u8) = undefined,
    kinds: std.ArrayList(i64) = undefined,
    tags: std.ArrayList([][]const u8) = undefined,
    since: i64 = 0,
    until: i64 = 0,
    limit: i64 = 0,
    search: []const u8 = undefined,
    allocator: std.mem.Allocator,

    pub fn empty(self: *const Filter) bool {
        return self.ids.items.len == 0 and
            self.authors.items.len == 0 and
            self.kinds.items.len == 0 and
            self.tags.items.len == 0 and
            self.since == 0 and
            self.until == 0 and
            self.search.len == 0;
    }

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) Self {
        return .{
            .ids = std.ArrayList([]const u8).init(allocator),
            .authors = std.ArrayList([]const u8).init(allocator),
            .tags = std.ArrayList([][]const u8).init(allocator),
            .kinds = std.ArrayList(i64).init(allocator),
            .search = "",
            .since = 0,
            .until = 0,
            .limit = 500,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: Self) void {
        self.ids.deinit();
        self.authors.deinit();
        self.kinds.deinit();
        self.tags.deinit();
        if (self.search.len > 0) self.allocator.free(self.search);
    }
};
