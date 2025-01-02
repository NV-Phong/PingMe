import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Lưu access token vào secure storage
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  // Lưu refresh token vào secure storage
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  // Đọc access token từ secure storage
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  // Đọc refresh token từ secure storage
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  // Xóa access token khỏi secure storage
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: 'access_token');
  }

  // Xóa refresh token khỏi secure storage
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  // Xóa tất cả các token
  Future<void> clearTokens() async {
    await _secureStorage.deleteAll();
  }
}
