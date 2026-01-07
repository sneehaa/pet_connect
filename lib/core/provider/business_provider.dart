// core/providers/business_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';

final businessIdProvider = FutureProvider<String?>((ref) async {
  final secureStorage = ref.read(flutterSecureStorageProvider);
  return await secureStorage.read(key: 'businessId');
});
