import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KSSecureStorageService {
  static Future<void> addValue(String key, String value) async {
    /// Create storage
    const storage = FlutterSecureStorage();
    return await storage.write(key: key, value: value);
  }

  static Future<String?> readValue(String key) async {
    /// Create storage
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future<void> deleteValue(String key) async {
    /// Create storage
    const storage = FlutterSecureStorage();
    return await storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    /// Create storage
    const storage = FlutterSecureStorage();
    return await storage.deleteAll();
  }
}
