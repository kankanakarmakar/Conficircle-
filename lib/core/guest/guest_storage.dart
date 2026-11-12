// lib/core/guest/guest_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kGuestRef = 'cc_guest_ref';

/// Secure storage wrapper for the guest session reference.
class GuestStorage {
  const GuestStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveGuestRef(String guestRef) =>
      _storage.write(key: _kGuestRef, value: guestRef);

  Future<String?> getGuestRef() => _storage.read(key: _kGuestRef);

  Future<void> clearGuestRef() => _storage.delete(key: _kGuestRef);
}

/// Riverpod provider for [GuestStorage].
final guestStorageProvider = Provider<GuestStorage>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return GuestStorage(storage);
});
