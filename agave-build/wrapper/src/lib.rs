//! Agave's per-signature check: `perf/src/sigverify.rs` at e818d643
//! calls `signature.verify(pubkey.as_ref(), message)`.

use solana_signature::Signature;

/// `Signature::verify` on a 32-byte key, 64-byte signature and message.
/// `C-unwind` lets a panic unwind, as in Agave; `C` would add an abort pad.
///
/// # Safety
/// `msg` points to `msg_len` readable bytes.
#[unsafe(no_mangle)]
pub unsafe extern "C-unwind" fn agave_ed25519_verify(
    pubkey: &[u8; 32],
    signature: &[u8; 64],
    msg: *const u8,
    msg_len: usize,
) -> bool {
    let message = unsafe { core::slice::from_raw_parts(msg, msg_len) };
    Signature::from(*signature).verify(pubkey, message)
}
