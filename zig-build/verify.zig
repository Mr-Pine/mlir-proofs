const Ed25519 = @import("src/ed25519.zig").Ed25519;

/// `Signature.verify`'s result as an integer: 0 on success, a distinct negative code per error.
export fn zig_ed25519_verify(msg: [*]const u8, msg_len: usize, sig: *const [64]u8, public_key: *const [32]u8) c_int {
    const s = Ed25519.Signature.fromBytes(sig.*);
    s.verify(msg[0..msg_len], .{ .bytes = public_key.* }) catch |err| return switch (err) {
        error.NonCanonical => -1,
        error.InvalidEncoding => -2,
        error.IdentityElement => -3,
        error.WeakPublicKey => -4,
        error.SignatureVerificationFailed => -5,
    };
    return 0;
}
