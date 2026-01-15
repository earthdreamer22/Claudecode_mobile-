import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'entities/user_profile.dart';
import 'entities/receipt.dart';
import 'entities/food_item.dart';
// import 'entities/health_stat.dart'; // 주석 처리 (미구현)

part 'app_database.g.dart';

/// Drift 데이터베이스 클래스
@DriftDatabase(tables: [UserProfile, Receipts, FoodItems]) // HealthStats 주석 처리 (미구현)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 향후 버전 업그레이드시 마이그레이션 로직 추가
      },
    );
  }

  // ========== UserProfile CRUD ==========

  /// 사용자 프로필 생성
  Future<int> createUserProfile(UserProfileCompanion profile) async {
    return into(userProfile).insert(profile);
  }

  /// 사용자 프로필 조회
  Future<UserProfileData?> getUserProfile(int userId) async {
    return (select(userProfile)..where((t) => t.id.equals(userId)))
        .getSingleOrNull();
  }

  /// 첫 번째 사용자 프로필 조회 (단일 사용자 앱)
  Future<UserProfileData?> getFirstUserProfile() async {
    return (select(userProfile)..limit(1)).getSingleOrNull();
  }

  /// 사용자 프로필 업데이트
  Future<bool> updateUserProfile(UserProfileData profile) async {
    return update(userProfile).replace(profile);
  }

  // ========== Receipts CRUD ==========

  /// 영수증 생성
  Future<int> createReceipt(ReceiptsCompanion receipt) async {
    return into(receipts).insert(receipt);
  }

  /// 영수증 조회 (ID)
  Future<ReceiptData?> getReceipt(int receiptId) async {
    return (select(receipts)..where((t) => t.id.equals(receiptId)))
        .getSingleOrNull();
  }

  /// 사용자의 모든 영수증 조회 (최신순)
  Future<List<ReceiptData>> getReceiptsByUser(int userId) async {
    return (select(receipts)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.receiptDate)]))
        .get();
  }

  /// 영수증 삭제
  Future<int> deleteReceipt(int receiptId) async {
    return (delete(receipts)..where((t) => t.id.equals(receiptId))).go();
  }

  // ========== FoodItems CRUD ==========

  /// 식료품 추가
  Future<int> createFoodItem(FoodItemsCompanion item) async {
    return into(foodItems).insert(item);
  }

  /// 여러 식료품 일괄 추가
  Future<void> createFoodItemsBatch(List<FoodItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(foodItems, items);
    });
  }

  /// 영수증의 모든 식료품 조회
  Future<List<FoodItemData>> getFoodItemsByReceipt(int receiptId) async {
    return (select(foodItems)..where((t) => t.receiptId.equals(receiptId)))
        .get();
  }

  /// 특정 날짜의 모든 식료품 조회
  Future<List<FoodItemData>> getFoodItemsByDate(
      int userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(foodItems).join([
      innerJoin(receipts, receipts.id.equalsExp(foodItems.receiptId))
    ])
          ..where(receipts.userId.equals(userId) &
              receipts.receiptDate.isBiggerOrEqualValue(startOfDay) &
              receipts.receiptDate.isSmallerThanValue(endOfDay)))
        .map((row) => row.readTable(foodItems))
        .get();
  }

  /// 식료품 삭제
  Future<int> deleteFoodItem(int itemId) async {
    return (delete(foodItems)..where((t) => t.id.equals(itemId))).go();
  }

  // ========== HealthStats CRUD (주석 처리 - 미구현) ==========

  // /// 건강 통계 생성 또는 업데이트
  // Future<void> upsertHealthStat(HealthStatsCompanion stat) async {
  //   await into(healthStats).insertOnConflictUpdate(stat);
  // }

  // /// 특정 날짜의 건강 통계 조회
  // Future<HealthStatData?> getHealthStatByDate(
  //     int userId, DateTime date) async {
  //   final targetDate = DateTime(date.year, date.month, date.day);

  //   return (select(healthStats)
  //         ..where((t) =>
  //             t.userId.equals(userId) & t.date.equals(targetDate)))
  //       .getSingleOrNull();
  // }

  // /// 날짜 범위로 건강 통계 조회
  // Future<List<HealthStatData>> getHealthStatsByDateRange(
  //     int userId, DateTime startDate, DateTime endDate) async {
  //   return (select(healthStats)
  //         ..where((t) =>
  //             t.userId.equals(userId) &
  //             t.date.isBiggerOrEqualValue(startDate) &
  //             t.date.isSmallerOrEqualValue(endDate))
  //         ..orderBy([(t) => OrderingTerm.asc(t.date)]))
  //       .get();
  // }

  // /// 최근 N일의 건강 통계 조회
  // Future<List<HealthStatData>> getRecentHealthStats(
  //     int userId, int days) async {
  //   final endDate = DateTime.now();
  //   final startDate = endDate.subtract(Duration(days: days));

  //   return getHealthStatsByDateRange(userId, startDate, endDate);
  // }

  // /// 월별 평균 대사증후군 점수 조회
  // Future<List<Map<String, dynamic>>> getMonthlyAverageScores(
  //     int userId, int months) async {
  //   // Raw query를 사용하여 월별 평균 계산
  //   final query = '''
  //     SELECT
  //       strftime('%Y-%m', date) as month,
  //       AVG(metabolic_score) as avg_score
  //     FROM health_stats
  //     WHERE user_id = ?
  //     AND date >= date('now', '-$months months')
  //     GROUP BY month
  //     ORDER BY month DESC
  //   ''';

  //   final result = await customSelect(
  //     query,
  //     variables: [Variable(userId)],
  //     readsFrom: {healthStats},
  //   ).get();

  //   return result.map((row) => row.data).toList();
  // }
}

/// 데이터베이스 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rhp_database.db'));
    return NativeDatabase(file);
  });
}
