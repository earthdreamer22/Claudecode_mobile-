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

  // ========== NutritionAnalysis CRUD ==========

  /// 영양 분석 결과 저장
  Future<int> saveNutritionAnalysis({
    required int userId,
    required NutritionAdviceResult advice,
  }) async {
    return await _db.createNutritionAnalysis(
      NutritionAnalysesCompanion.insert(
        userId: userId,
        analysisDate: DateTime.now(),
        overallScore: advice.overallAssessment.score,
        overallLevel: advice.overallAssessment.level,
        overallSummary: advice.overallAssessment.summary,
        personalizedTips: jsonEncode(advice.personalizedTips),
        futurePredictions: jsonEncode(
          advice.futurePredictions.map((k, v) => MapEntry(k, v.toJson())),
        ),
        actionPlan: jsonEncode(advice.actionPlan.toJson()),
        categoryAnalysis: jsonEncode(
          advice.categoryAnalysis.map((k, v) => MapEntry(k, v.toJson())),
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
    // personalizedTips 파싱
    final tips = (jsonDecode(data.personalizedTips) as List).cast<String>();

    // futurePredictions 파싱
    final futureMap = <String, FuturePrediction>{};
    final futureJson = jsonDecode(data.futurePredictions) as Map<String, dynamic>;
    futureJson.forEach((key, value) {
      futureMap[key] = FuturePrediction.fromJson(value);
    });

    // actionPlan 파싱
    final actionJson = jsonDecode(data.actionPlan) as Map<String, dynamic>;
    final actionPlan = ActionPlan.fromJson(actionJson);

    // categoryAnalysis 파싱
    final categoryMap = <String, CategoryAnalysis>{};
    final categoryJson = jsonDecode(data.categoryAnalysis) as Map<String, dynamic>;
    categoryJson.forEach((key, value) {
      categoryMap[key] = CategoryAnalysis.fromJson(value);
    });

    return NutritionAdviceResult(
      overallAssessment: OverallAssessment(
        score: data.overallScore,
        level: data.overallLevel,
        summary: data.overallSummary,
      ),
      categoryAnalysis: categoryMap,
      nutritionBalance: NutritionBalance(
        sodium: NutritionStatus(status: '알 수 없음', advice: ''),
        sugar: NutritionStatus(status: '알 수 없음', advice: ''),
        calories: NutritionStatus(status: '알 수 없음', advice: ''),
      ),
      personalizedTips: tips,
      futurePredictions: futureMap,
      actionPlan: actionPlan,
    );
  }

  /// 영양 분석 결과 존재 여부 확인
  Future<bool> hasNutritionAnalysis(int userId) async {
    final data = await _db.getLatestNutritionAnalysis(userId);
    return data != null;
  }
}
