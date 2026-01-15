import 'dart:convert';
import 'package:logger/logger.dart';
import '../data/models/prediction_result.dart';
import '../data/database/app_database.dart';
import '../config/constants.dart';

/// 대사증후군 위험도 예측 엔진
class PredictionEngine {
  final _logger = Logger();

  /// 종합 위험도 예측
  Future<PredictionResult> predictMetabolicRisk({
    required UserProfileData user,
    required List<FoodItemData> recentFoodItems,
    int analyzeDays = 7,
  }) async {
    try {
      _logger.i('위험도 예측 시작 (${analyzeDays}일 분석)');

      // 1. BMI 계산 및 점수화
      final bmiScore = _calculateBmiScore(user);

      // 2. 영양 섭취 분석
      final nutritionScore = _calculateNutritionScore(recentFoodItems);

      // 3. 가족력 점수
      final familyHistoryScore = _calculateFamilyHistoryScore(user);

      // 4. 기존 질환 점수
      final existingConditionScore =
          _calculateExistingConditionScore(user);

      // 5. 종합 대사 점수 계산 (가중 평균)
      final metabolicScore = _calculateWeightedScore(
        bmiScore: bmiScore,
        nutritionScore: nutritionScore,
        familyHistoryScore: familyHistoryScore,
        existingConditionScore: existingConditionScore,
      );

      // 6. 위험도 등급 판정
      final riskLevel = _determineRiskLevel(metabolicScore);

      // 7. 맞춤 추천 생성
      final recommendations = _generateRecommendations(
        user: user,
        foodItems: recentFoodItems,
        riskLevel: riskLevel,
        bmiScore: bmiScore,
        nutritionScore: nutritionScore,
      );

      // 8. 세부 분석 결과
      final details = _generateDetailedAnalysis(
        user: user,
        foodItems: recentFoodItems,
        bmiScore: bmiScore,
        nutritionScore: nutritionScore,
      );

      // 9. 미래 예측
      final futurePredictions = _predictFutureRisk(
        currentScore: metabolicScore,
        riskLevel: riskLevel,
      );

      // 영양소 합계 계산
      final totalCalories = details['avgCalories'].toInt();
      final totalSodium = details['avgSodiumMg'].toInt();
      final totalSugar = details['avgSugarG'];
      final totalFat = details['avgFatG'];
      final totalProtein = recentFoodItems.isNotEmpty
          ? recentFoodItems
                  .where((f) => f.proteinG != null)
                  .map((f) => f.proteinG!)
                  .fold<double>(0, (sum, p) => sum + p) /
              recentFoodItems.length
          : 0.0;
      final totalCarbs = recentFoodItems.isNotEmpty
          ? recentFoodItems
                  .where((f) => f.carbsG != null)
                  .map((f) => f.carbsG!)
                  .fold<double>(0, (sum, c) => sum + c) /
              recentFoodItems.length
          : 0.0;

      final result = PredictionResult(
        metabolicScore: metabolicScore,
        riskLevel: riskLevel,
        recommendations: recommendations,
        riskFactors: {
          'BMI': bmiScore,
          '영양': nutritionScore,
          '가족력': familyHistoryScore,
          '기존질환': existingConditionScore,
        },
        futurePredictions: futurePredictions.map((k, v) {
          // 점수를 변환 (위험도 텍스트를 점수로)
          double score = 0.0;
          switch (v) {
            case '정상':
              score = 10.0;
              break;
            case '주의':
              score = 40.0;
              break;
            case '위험':
              score = 65.0;
              break;
            case '고위험':
              score = 85.0;
              break;
          }
          return MapEntry(k, score);
        }),
        totalCaloriesDaily: totalCalories,
        totalSodiumDailyMg: totalSodium,
        totalSugarDailyG: totalSugar,
        totalFatDailyG: totalFat,
        totalProteinDailyG: totalProtein,
        totalCarbsDailyG: totalCarbs,
        bmi: details['bmi'],
        age: user.age,
        gender: user.gender,
      );

      _logger.i('예측 완료: $riskLevel (점수: ${metabolicScore.toStringAsFixed(1)})');
      return result;
    } catch (e) {
      _logger.e('예측 실패: $e');
      rethrow;
    }
  }

  /// BMI 점수 계산 (0-100)
  double _calculateBmiScore(UserProfileData user) {
    final bmi = user.weight / ((user.height / 100) * (user.height / 100));

    // BMI 점수화 (낮을수록 좋음)
    if (bmi < AppConstants.bmiUnderweight) {
      return 30.0; // 저체중도 위험
    } else if (bmi < AppConstants.bmiNormal) {
      return 10.0; // 정상 - 가장 낮은 위험
    } else if (bmi < AppConstants.bmiOverweight) {
      return 30.0; // 과체중
    } else if (bmi < AppConstants.bmiObese) {
      return 60.0; // 비만
    } else {
      return 90.0; // 고도비만
    }
  }

  /// 영양 섭취 점수 계산 (0-100)
  double _calculateNutritionScore(List<FoodItemData> foodItems) {
    if (foodItems.isEmpty) {
      return 50.0; // 데이터 없음 - 중간값
    }

    double totalScore = 0.0;
    int scoreCount = 0;

    // 1. 나트륨 점수 (일일 권장량 2000mg 기준)
    final avgSodium = foodItems
            .where((f) => f.sodiumMg != null)
            .map((f) => f.sodiumMg!)
            .fold<int>(0, (sum, sodium) => sum + sodium) /
        foodItems.length;

    if (avgSodium > 0) {
      final sodiumRatio = avgSodium / AppConstants.dailySodiumLimitMg;
      final sodiumScore = (sodiumRatio * 100).clamp(0, 100);
      totalScore += sodiumScore;
      scoreCount++;
    }

    // 2. 칼로리 점수 (일일 권장량 2000kcal 기준)
    final avgCalories = foodItems
            .where((f) => f.calories != null)
            .map((f) => f.calories!)
            .fold<int>(0, (sum, cal) => sum + cal) /
        foodItems.length;

    if (avgCalories > 0) {
      final calorieRatio = avgCalories / AppConstants.dailyCaloriesLimitKcal;
      final calorieScore = (calorieRatio * 100).clamp(0, 100);
      totalScore += calorieScore;
      scoreCount++;
    }

    // 3. 당류 점수 (일일 권장량 50g 기준)
    final avgSugar = foodItems
            .where((f) => f.sugarG != null)
            .map((f) => f.sugarG!)
            .fold<double>(0, (sum, sugar) => sum + sugar) /
        foodItems.length;

    if (avgSugar > 0) {
      final sugarRatio = avgSugar / AppConstants.dailySugarLimitG;
      final sugarScore = (sugarRatio * 100).clamp(0, 100);
      totalScore += sugarScore;
      scoreCount++;
    }

    // 4. 지방 점수 (일일 권장량 50g 기준)
    final avgFat = foodItems
            .where((f) => f.fatG != null)
            .map((f) => f.fatG!)
            .fold<double>(0, (sum, fat) => sum + fat) /
        foodItems.length;

    if (avgFat > 0) {
      final fatRatio = avgFat / AppConstants.dailyFatLimitG;
      final fatScore = (fatRatio * 100).clamp(0, 100);
      totalScore += fatScore;
      scoreCount++;
    }

    return scoreCount > 0 ? totalScore / scoreCount : 50.0;
  }

  /// 가족력 점수 (0-100)
  double _calculateFamilyHistoryScore(UserProfileData user) {
    int riskFactors = 0;

    try {
      final familyHistory = jsonDecode(user.familyHistory) as Map<String, dynamic>;
      if (familyHistory['diabetes'] == true) riskFactors++;
      if (familyHistory['hypertension'] == true) riskFactors++;
      if (familyHistory['heartDisease'] == true) riskFactors++;
      if (familyHistory['dyslipidemia'] == true) riskFactors++;
    } catch (e) {
      _logger.w('가족력 파싱 실패: $e');
    }

    // 가족력 1개당 15점
    return (riskFactors * 15.0).clamp(0, 60);
  }

  /// 기존 질환 점수 (0-100)
  double _calculateExistingConditionScore(UserProfileData user) {
    try {
      final conditions = jsonDecode(user.existingConditions) as Map<String, dynamic>;
      // 하나라도 질환이 있으면 50점
      return conditions.values.any((v) => v == true) ? 50.0 : 0.0;
    } catch (e) {
      _logger.w('기존질환 파싱 실패: $e');
      return 0.0;
    }
  }

  /// 가중 평균 점수 계산
  double _calculateWeightedScore({
    required double bmiScore,
    required double nutritionScore,
    required double familyHistoryScore,
    required double existingConditionScore,
  }) {
    // 가중치: BMI(30%), 영양(40%), 가족력(20%), 기존질환(10%)
    return (bmiScore * 0.3) +
        (nutritionScore * 0.4) +
        (familyHistoryScore * 0.2) +
        (existingConditionScore * 0.1);
  }

  /// 위험도 등급 판정
  String _determineRiskLevel(double score) {
    if (score < 25) {
      return '정상';
    } else if (score < 50) {
      return '주의';
    } else if (score < 75) {
      return '위험';
    } else {
      return '고위험';
    }
  }

  /// 맞춤 추천 생성
  List<String> _generateRecommendations({
    required UserProfileData user,
    required List<FoodItemData> foodItems,
    required String riskLevel,
    required double bmiScore,
    required double nutritionScore,
  }) {
    final recommendations = <String>[];

    // BMI 관련 추천
    final bmi = user.weight / ((user.height / 100) * (user.height / 100));
    if (bmi >= AppConstants.bmiOverweight) {
      recommendations.add('체중 감량이 필요합니다. 일주일에 0.5-1kg 감량을 목표로 하세요.');
      recommendations.add('유산소 운동(걷기, 조깅)을 하루 30분 이상 실천하세요.');
    } else if (bmi < AppConstants.bmiUnderweight) {
      recommendations.add('체중 증가가 필요합니다. 균형 잡힌 식사를 규칙적으로 하세요.');
    }

    // 나트륨 관련 추천
    final avgSodium = foodItems.isNotEmpty
        ? foodItems
                .where((f) => f.sodiumMg != null)
                .map((f) => f.sodiumMg!)
                .fold<int>(0, (sum, s) => sum + s) /
            foodItems.length
        : 0;

    if (avgSodium > AppConstants.dailySodiumLimitMg * 0.8) {
      recommendations.add('나트륨 섭취를 줄이세요. 가공식품과 짠 음식을 피하세요.');
      recommendations.add('신선한 채소와 과일을 충분히 섭취하세요.');
    }

    // 당류 관련 추천
    final avgSugar = foodItems.isNotEmpty
        ? foodItems
                .where((f) => f.sugarG != null)
                .map((f) => f.sugarG!)
                .fold<double>(0, (sum, s) => sum + s) /
            foodItems.length
        : 0;

    if (avgSugar > AppConstants.dailySugarLimitG * 0.8) {
      recommendations.add('당류 섭취를 줄이세요. 탄산음료와 과자를 피하세요.');
      recommendations.add('물을 충분히 마시고, 단 음료 대신 무가당 음료를 선택하세요.');
    }

    // 가족력 관련 추천
    try {
      final familyHistory = jsonDecode(user.familyHistory) as Map<String, dynamic>;
      if (familyHistory['diabetes'] == true || familyHistory['hypertension'] == true) {
        recommendations.add('가족력이 있으므로 정기적인 건강검진을 받으세요.');
        recommendations.add('혈당과 혈압을 주기적으로 측정하세요.');
      }
    } catch (e) {
      // JSON 파싱 실패 시 무시
    }

    // 일반적인 추천
    if (riskLevel == '위험' || riskLevel == '고위험') {
      recommendations.add('전문의와 상담하여 정밀 검사를 받으세요.');
      recommendations.add('스트레스 관리와 충분한 수면을 취하세요.');
    }

    if (recommendations.isEmpty) {
      recommendations.add('현재 건강 상태가 양호합니다. 건강한 식습관을 유지하세요.');
      recommendations.add('규칙적인 운동과 균형 잡힌 식사를 계속하세요.');
    }

    return recommendations;
  }

  /// 세부 분석 생성
  Map<String, dynamic> _generateDetailedAnalysis({
    required UserProfileData user,
    required List<FoodItemData> foodItems,
    required double bmiScore,
    required double nutritionScore,
  }) {
    final bmi = user.weight / ((user.height / 100) * (user.height / 100));

    final avgSodium = foodItems.isNotEmpty
        ? foodItems
                .where((f) => f.sodiumMg != null)
                .map((f) => f.sodiumMg!)
                .fold<int>(0, (sum, s) => sum + s) /
            foodItems.length
        : 0;

    final avgCalories = foodItems.isNotEmpty
        ? foodItems
                .where((f) => f.calories != null)
                .map((f) => f.calories!)
                .fold<int>(0, (sum, c) => sum + c) /
            foodItems.length
        : 0;

    final avgSugar = foodItems.isNotEmpty
        ? foodItems
                .where((f) => f.sugarG != null)
                .map((f) => f.sugarG!)
                .fold<double>(0, (sum, s) => sum + s) /
            foodItems.length
        : 0;

    final avgFat = foodItems.isNotEmpty
        ? foodItems
                .where((f) => f.fatG != null)
                .map((f) => f.fatG!)
                .fold<double>(0, (sum, f) => sum + f) /
            foodItems.length
        : 0;

    return {
      'bmi': bmi,
      'bmiStatus': _getBmiStatus(bmi),
      'avgSodiumMg': avgSodium,
      'sodiumPercent': (avgSodium / AppConstants.dailySodiumLimitMg * 100),
      'avgCalories': avgCalories,
      'caloriePercent': (avgCalories / AppConstants.dailyCaloriesLimitKcal * 100),
      'avgSugarG': avgSugar,
      'sugarPercent': (avgSugar / AppConstants.dailySugarLimitG * 100),
      'avgFatG': avgFat,
      'fatPercent': (avgFat / AppConstants.dailyFatLimitG * 100),
      'analyzedItemCount': foodItems.length,
    };
  }

  /// BMI 상태 텍스트
  String _getBmiStatus(double bmi) {
    if (bmi < AppConstants.bmiUnderweight) {
      return '저체중';
    } else if (bmi < AppConstants.bmiNormal) {
      return '정상';
    } else if (bmi < AppConstants.bmiOverweight) {
      return '과체중';
    } else if (bmi < AppConstants.bmiObese) {
      return '비만';
    } else {
      return '고도비만';
    }
  }

  /// 미래 위험도 예측
  Map<String, String> _predictFutureRisk({
    required double currentScore,
    required String riskLevel,
  }) {
    // 현재 추세를 기반으로 미래 예측
    // 간단한 선형 모델 사용

    final predictions = <String, String>{};

    // 1년 후
    final score1Year = _extrapolateScore(currentScore, 1);
    predictions['1년'] = _determineRiskLevel(score1Year);

    // 3년 후
    final score3Year = _extrapolateScore(currentScore, 3);
    predictions['3년'] = _determineRiskLevel(score3Year);

    // 5년 후
    final score5Year = _extrapolateScore(currentScore, 5);
    predictions['5년'] = _determineRiskLevel(score5Year);

    return predictions;
  }

  /// 점수 외삽 (간단한 선형 증가 모델)
  double _extrapolateScore(double currentScore, int years) {
    // 현재 위험도에 따라 증가율 다르게 적용
    double growthRate;

    if (currentScore < 25) {
      growthRate = 0.02; // 정상: 연 2% 증가
    } else if (currentScore < 50) {
      growthRate = 0.05; // 주의: 연 5% 증가
    } else if (currentScore < 75) {
      growthRate = 0.08; // 위험: 연 8% 증가
    } else {
      growthRate = 0.10; // 고위험: 연 10% 증가
    }

    final futureScore = currentScore * (1 + growthRate * years);
    return futureScore.clamp(0, 100);
  }

  /// 카테고리별 식품 섭취 분석
  Map<String, int> analyzeFoodCategories(List<FoodItemData> foodItems) {
    final categoryCounts = <String, int>{};

    for (final item in foodItems) {
      categoryCounts[item.category] = (categoryCounts[item.category] ?? 0) + 1;
    }

    return categoryCounts;
  }

  /// 주간 추세 분석
  Map<String, double> analyzeWeeklyTrend(List<FoodItemData> foodItems) {
    // 날짜별로 그룹화하여 추세 분석
    final dailyAverages = <DateTime, double>{};

    for (final item in foodItems) {
      final date =
          DateTime(item.addedAt.year, item.addedAt.month, item.addedAt.day);
      // 간단한 위험도 지표: 나트륨 + 칼로리
      final risk = (item.sodiumMg ?? 0) / 10 + (item.calories ?? 0) / 20;
      dailyAverages[date] = (dailyAverages[date] ?? 0) + risk;
    }

    return {
      'avgDailyRisk':
          dailyAverages.values.fold(0.0, (sum, v) => sum + v) /
              (dailyAverages.length > 0 ? dailyAverages.length : 1),
      'maxDailyRisk': dailyAverages.values.isEmpty
          ? 0.0
          : dailyAverages.values.reduce((a, b) => a > b ? a : b),
      'minDailyRisk': dailyAverages.values.isEmpty
          ? 0.0
          : dailyAverages.values.reduce((a, b) => a < b ? a : b),
    };
  }
}
