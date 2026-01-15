/// 대사증후군 예측 결과 모델
class PredictionResult {
  final double metabolicScore; // 대사증후군 위험도 점수 (0-100)
  final String riskLevel; // 위험 레벨: SAFE, CAUTION, WARNING, DANGER
  final List<String> recommendations; // AI 추천사항
  final Map<String, double> riskFactors; // 위험 요인별 기여도

  // 미래 예측 (1년, 3년, 5년)
  final Map<String, double> futurePredictions;

  // 일일 영양소 합계
  final int totalCaloriesDaily;
  final int totalSodiumDailyMg;
  final double totalSugarDailyG;
  final double totalFatDailyG;
  final double totalProteinDailyG;
  final double totalCarbsDailyG;

  // 사용자 정보
  final double bmi;
  final int age;
  final String gender;

  PredictionResult({
    required this.metabolicScore,
    required this.riskLevel,
    required this.recommendations,
    required this.riskFactors,
    required this.futurePredictions,
    required this.totalCaloriesDaily,
    required this.totalSodiumDailyMg,
    required this.totalSugarDailyG,
    required this.totalFatDailyG,
    required this.totalProteinDailyG,
    required this.totalCarbsDailyG,
    required this.bmi,
    required this.age,
    required this.gender,
  });

  /// 위험도 레벨 텍스트 반환
  String get riskLevelText {
    switch (riskLevel) {
      case 'SAFE':
        return '안전';
      case 'CAUTION':
        return '주의';
      case 'WARNING':
        return '경고';
      case 'DANGER':
        return '위험';
      default:
        return '알 수 없음';
    }
  }

  /// 점수를 퍼센트로 반환
  String get scorePercent => '${metabolicScore.toStringAsFixed(1)}%';

  /// 나트륨 초과 여부
  bool get isSodiumExcess => totalSodiumDailyMg > 2000;

  /// 당류 초과 여부
  bool get isSugarExcess => totalSugarDailyG > 50;

  /// 칼로리 초과 여부
  bool get isCaloriesExcess => totalCaloriesDaily > 2000;

  /// BMI 과체중 여부
  bool get isOverweight => bmi >= 25.0;

  @override
  String toString() {
    return 'PredictionResult(score: $metabolicScore, level: $riskLevel, '
        'bmi: $bmi, sodium: $totalSodiumDailyMg mg, sugar: $totalSugarDailyG g)';
  }

  /// JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'metabolicScore': metabolicScore,
      'riskLevel': riskLevel,
      'recommendations': recommendations,
      'riskFactors': riskFactors,
      'futurePredictions': futurePredictions,
      'totalCaloriesDaily': totalCaloriesDaily,
      'totalSodiumDailyMg': totalSodiumDailyMg,
      'totalSugarDailyG': totalSugarDailyG,
      'totalFatDailyG': totalFatDailyG,
      'totalProteinDailyG': totalProteinDailyG,
      'totalCarbsDailyG': totalCarbsDailyG,
      'bmi': bmi,
      'age': age,
      'gender': gender,
    };
  }

  /// JSON 역직렬화
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      metabolicScore: (json['metabolicScore'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      recommendations: List<String>.from(json['recommendations'] as List),
      riskFactors: Map<String, double>.from(json['riskFactors'] as Map),
      futurePredictions:
          Map<String, double>.from(json['futurePredictions'] as Map),
      totalCaloriesDaily: json['totalCaloriesDaily'] as int,
      totalSodiumDailyMg: json['totalSodiumDailyMg'] as int,
      totalSugarDailyG: (json['totalSugarDailyG'] as num).toDouble(),
      totalFatDailyG: (json['totalFatDailyG'] as num).toDouble(),
      totalProteinDailyG: (json['totalProteinDailyG'] as num).toDouble(),
      totalCarbsDailyG: (json['totalCarbsDailyG'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      age: json['age'] as int,
      gender: json['gender'] as String,
    );
  }
}
