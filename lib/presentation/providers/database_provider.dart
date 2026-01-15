import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/receipt_repository.dart';
// import '../../data/repositories/health_repository.dart'; // 주석 처리 (미구현)

/// 데이터베이스 인스턴스 Provider (싱글톤)
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// UserRepository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return UserRepository(db);
});

/// ReceiptRepository Provider
final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ReceiptRepository(db);
});

// /// HealthRepository Provider (주석 처리 - 미구현)
// final healthRepositoryProvider = Provider<HealthRepository>((ref) {
//   final db = ref.watch(databaseProvider);
//   return HealthRepository(db);
// });
