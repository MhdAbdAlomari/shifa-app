import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

class AuthTokenStorage {
  final FlutterSecureStorage _storage;

  AuthTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> read() => _storage.read(key: StorageKeys.authToken);

  Future<void> write(String token) =>
      _storage.write(key: StorageKeys.authToken, value: token);

  Future<void> clear() => _storage.delete(key: StorageKeys.authToken);
}
