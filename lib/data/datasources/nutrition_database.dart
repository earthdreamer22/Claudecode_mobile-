import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/nutrition.dart';

/// 식료품 영양정보 데이터베이스
class NutritionDatabase {
  static List<Nutrition>? _cachedFoods;

  /// JSON 파일에서 식료품 데이터 로드
  static Future<List<Nutrition>> loadNutritionData() async {
    if (_cachedFoods != null) {
      return _cachedFoods!;
    }

    try {
      final jsonString =
          await rootBundle.loadString('assets/nutrition_data.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final foods = data['foods'] as List<dynamic>;

      _cachedFoods =
          foods.map((f) => Nutrition.fromJson(f as Map<String, dynamic>)).toList();

      return _cachedFoods!;
    } catch (e) {
      throw Exception('영양정보 DB 로드 실패: $e');
    }
  }

  /// 상품명으로 검색 (정확 매칭)
  static Future<Nutrition?> searchByName(String name) async {
    final foods = await loadNutritionData();
    try {
      return foods.firstWhere(
        (f) => f.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// 상품명으로 검색 (부분 매칭)
  static Future<List<Nutrition>> searchByPartialName(String query) async {
    final foods = await loadNutritionData();
    final lowerQuery = query.toLowerCase();

    return foods
        .where((f) => f.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// 카테고리로 필터링
  static Future<List<Nutrition>> filterByCategory(String category) async {
    final foods = await loadNutritionData();
    return foods.where((f) => f.category == category).toList();
  }

  /// 유사도 기반 검색 (간단한 Levenshtein Distance)
  static Future<Nutrition?> searchBySimilarity(
    String query, {
    double threshold = 0.6,
  }) async {
    final foods = await loadNutritionData();
    if (foods.isEmpty) return null;

    double bestScore = 0.0;
    Nutrition? bestMatch;

    for (final food in foods) {
      final score = _calculateSimilarity(query, food.name);
      if (score > bestScore && score >= threshold) {
        bestScore = score;
        bestMatch = food;
      }
    }

    return bestMatch;
  }

  /// 여러 키워드로 검색
  static Future<List<Nutrition>> searchByKeywords(
      List<String> keywords) async {
    final foods = await loadNutritionData();
    final results = <Nutrition>[];

    for (final keyword in keywords) {
      final matches = await searchByPartialName(keyword);
      results.addAll(matches);
    }

    // 중복 제거
    return results.toSet().toList();
  }

  /// 나트륨 함량 기준 정렬 (높은 순)
  static Future<List<Nutrition>> sortBySodium({bool descending = true}) async {
    final foods = await loadNutritionData();
    final sorted = List<Nutrition>.from(foods);

    sorted.sort((a, b) =>
        descending ? b.sodiumMg.compareTo(a.sodiumMg) : a.sodiumMg.compareTo(b.sodiumMg));

    return sorted;
  }

  /// 당류 함량 기준 정렬 (높은 순)
  static Future<List<Nutrition>> sortBySugar({bool descending = true}) async {
    final foods = await loadNutritionData();
    final sorted = List<Nutrition>.from(foods);

    sorted.sort((a, b) =>
        descending ? b.sugarG.compareTo(a.sugarG) : a.sugarG.compareTo(b.sugarG));

    return sorted;
  }

  /// 전체 식료품 개수
  static Future<int> getTotalCount() async {
    final foods = await loadNutritionData();
    return foods.length;
  }

  /// 카테고리별 개수
  static Future<Map<String, int>> getCategoryCount() async {
    final foods = await loadNutritionData();
    final counts = <String, int>{};

    for (final food in foods) {
      counts[food.category] = (counts[food.category] ?? 0) + 1;
    }

    return counts;
  }

  /// 캐시 초기화
  static void clearCache() {
    _cachedFoods = null;
  }

  // ========== Private Methods ==========

  /// 간단한 유사도 계산 (Jaro-Winkler 간소화 버전)
  static double _calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final lower1 = s1.toLowerCase();
    final lower2 = s2.toLowerCase();

    // 부분 문자열 포함 여부
    if (lower1.contains(lower2) || lower2.contains(lower1)) {
      return 0.8;
    }

    // 간단한 문자 일치도 계산
    int matches = 0;
    final minLength = s1.length < s2.length ? s1.length : s2.length;

    for (int i = 0; i < minLength; i++) {
      if (lower1[i] == lower2[i]) {
        matches++;
      }
    }

    return matches / (s1.length > s2.length ? s1.length : s2.length);
  }
}
