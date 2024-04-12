const std = @import("std");
const testing = std.testing;

const img_log = std.log.scoped(.image_zig);

pub fn imgLoader(file_path: []const u8) !bool {
    testing.log_level = .info;
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file_stat = try file.stat();
    // img_log.info("File size: {}", .{file_stat});
    const file_content = try file.readToEndAlloc(
        allocator,
        file_stat.size,
    );
    defer allocator.free(file_content);

    var create_img = std.fs.cwd().createFile(
        "test-files/test.txt",
        .{},
    ) catch unreachable;
    defer create_img.close();
    try create_img.writeAll(file_content);

    // var indexof = std.mem.indexOf(u8, file_content, "test") orelse unreachable;

    // const metadata = file.metadata();
    const width = file_content[0x0100];
    const height = file_content[0x0101];

    img_log.info("File content: {any} {any}", .{ width, height });
    // img_log.info("File content: {any}", .{metadata});
    img_log.info("File content: {b}", .{&file_content});

    return true;
}

test "adition test" {
    try testing.expect(try imgLoader("test-files/test.jpg"));
}
