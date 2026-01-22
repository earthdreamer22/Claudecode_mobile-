import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/nutrition.dart';
import '../../utils/llm_parser_service.dart';

/// 영수증 Repository
class ReceiptRepository {
  final AppDatabase _db;

  ReceiptRepository(this._db);

  /// 영수증 생성
  Future<int> createReceipt({
    required int userId,
    required String imagePath,
    required String ocrText,
    required int totalAmount,
    required int itemCount,
  }) async {
    return await _db.createReceipt(
      ReceiptsCompanion.insert(
        userId: userId,
        imagePath: imagePath,
        rawOcrText: ocrText,
        receiptDate: DateTime.now(),
        parsedItemCount: Value(itemCount),
        totalAmount: Value(totalAmount.toDouble()),
      ),
    );
  }

  /// 식료품 항목 생성
  Future<int> createFoodItem({
    required int receiptId,
    required String name,
    required String category,
    required int price,
    Nutrition? nutritionData,
  }) async {
    return await _db.createFoodItem(
      FoodItemsCompanion.insert(
        receiptId: receiptId,
        name: name,
        category: category,
        price: Value(price.toDouble()),
        calories: Value(nutritionData?.calories),
        sodiumMg: Value(nutritionData?.sodiumMg),
        sugarG: Value(nutritionData?.sugarG.toDouble()),
        fatG: Value(nutritionData?.fatG.toDouble()),
        proteinG: Value(nutritionData?.proteinG.toDouble()),
        carbsG: Value(nutritionData?.carbsG.toDouble()),
      ),
    );
  }

  /// 영수증 조회
  Future<ReceiptData?> getReceipt(int receiptId) async {
    return await _db.getReceipt(receiptId);
  }

  /// 사용자의 모든 영수증 조회 (최신순)
  Future<List<ReceiptData>> getReceiptsByUser(int userId) async {
    return await _db.getReceiptsByUser(userId);
  }

  /// 최근 N개 영수증 조회
  Future<List<ReceiptData>> getRecentReceipts(int userId, int limit) async {
    final allReceipts = await getReceiptsByUser(userId);
    return allReceipts.take(limit).toList();
  }

  /// 영수증 삭제
  Future<bool> deleteReceipt(int receiptId) async {
    final result = await _db.deleteReceipt(receiptId);
    return result > 0;
  }

  /// 영수증 통계: 총 개수
  Future<int> getTotalReceiptCount(int userId) async {
    final receipts = await getReceiptsByUser(userId);
    return receipts.length;
  }

  /// 영수증 통계: 이번 달 개수
  Future<int> getMonthlyReceiptCount(int userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final receipts = await getReceiptsByUser(userId);
    return receipts
        .where((r) =>
            r.receiptDate.isAfter(startOfMonth) &&
            r.receiptDate.isBefore(endOfMonth))
        .length;
  }

  /// 특정 날짜의 영수증 조회
  Future<List<ReceiptData>> getReceiptsByDate(
      int userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final receipts = await getReceiptsByUser(userId);
    return receipts
        .where((r) =>
            r.receiptDate.isAfter(startOfDay) &&
            r.receiptDate.isBefore(endOfDay))
        .toList();
  }

  /// 영수증의 식료품 항목 조회
  Future<List<FoodItemData>> getFoodItemsByReceipt(int receiptId) async {
    return await _db.getFoodItemsByReceipt(receiptId);
  }

  /// 식료품 항목 삭제
  Future<bool> deleteFoodItem(int foodItemId) async {
    final result = await _db.deleteFoodItem(foodItemId);
    return result > 0;
  }

  // ========== NutritionAnalysis CRUD (v2) ==========

  /// 영양 분석 결과 저장
  Future<int> saveNutritionAnalysis({
    required int userId,
    required NutritionAdviceResult advice,
  }) async {
    return await _db.createNutritionAnalysis(
      NutritionAnalysesCompanion.insert(
        userId: userId,
        analysisDate: DateTime.now(),
        dietCharacter: jsonEncode(advice.dietCharacter.toJson()),
        purchasePatterns: jsonEncode(
          advice.purchasePatterns.map((e) => e.toJson()).toList(),
        ),
        deficiencyWarnings: jsonEncode(
          advice.deficiencyWarnings.map((e) => e.toJson()).toList(),
        ),
        futureScenarios: jsonEncode(
          advice.futureScenarios.map((e) => e.toJson()).toList(),
        ),
        trendComparison: Value(
          advice.trendComparison != null
              ? jsonEncode(advice.trendComparison!.toJson())
              : null,
        ),
      ),
    );
  }

  /// 최신 영양 분석 결과 조회
  Future<NutritionAdviceResult?> getLatestNutritionAnalysis(int userId) async {
    final data = await _db.getLatestNutritionAnalysis(userId);
    if (data == null) return null;

    return _convertToNutritionAdvice(data);
  }

  /// DB 데이터를 NutritionAdviceResult로 변환
  NutritionAdviceResult _convertToNutritionAdvice(NutritionAnalysisData data) {
    // dietCharacter 파싱
    final characterJson = jsonDecode(data.dietCharacter) as Map<String, dynamic>;
    final dietCharacter = DietCharacter.fromJson(characterJson);

    // purchasePatterns 파싱
    final patternsJson = jsonDecode(data.purchasePatterns) as List;
    final purchasePatterns = patternsJson
        .map((e) => PurchasePatternInsight.fromJson(e))
        .toList();

    // deficiencyWarnings 파싱
    final warningsJson = jsonDecode(data.deficiencyWarnings) as List;
    final deficiencyWarnings = warningsJson
        .map((e) => DeficiencyWarning.fromJson(e))
        .toList();

    // futureScenarios 파싱
    final scenariosJson = jsonDecode(data.futureScenarios) as List;
    final futureScenarios = scenariosJson
        .map((e) => FutureHealthScenario.fromJson(e))
        .toList();

    // trendComparison 파싱 (nullable)
    TrendComparison? trendComparison;
    if (data.trendComparison != null) {
      final trendJson = jsonDecode(data.trendComparison!) as Map<String, dynamic>;
      trendComparison = TrendComparison.fromJson(trendJson);
    }

    return NutritionAdviceResult(
      dietCharacter: dietCharacter,
      purchasePatterns: purchasePatterns,
      deficiencyWarnings: deficiencyWarnings,
      futureScenarios: futureScenarios,
      trendComparison: trendComparison,
    );
  }

  /// 영양 분석 결과 존재 여부 확인
  Future<bool> hasNutritionAnalysis(int userId) async {
    final data = await _db.getLatestNutritionAnalysis(userId);
    return data != null;
  }
}
