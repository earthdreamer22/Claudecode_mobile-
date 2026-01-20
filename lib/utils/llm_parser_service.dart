import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// LLM API를 통한 영수증 파싱 서비스
class LlmParserService {
  final _logger = Logger();

  // Vercel 배포 URL
  static const String _baseUrl = 'https://claudecode-mobile.vercel.app/api';
  static const String _apiUrl = 'https://claudecode-mobile.vercel.app/api/parse-receipt';

  /// OCR 텍스트를 LLM으로 파싱
  Future<LlmParseResult?> parseReceipt({
    required String ocrText,
    List<Map<String, dynamic>>? blocks,
  }) async {
    try {
      _logger.i('LLM 파싱 시작');

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'ocrText': ocrText,
          'blocks': blocks,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final result = LlmParseResult.fromJson(data['data']);
          _logger.i('LLM 파싱 성공: ${result.items.length}개 항목');
          return result;
        }
      }

      _logger.e('LLM 파싱 실패: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      _logger.e('LLM 파싱 오류: $e');
      return null;
    }
  }

  /// 영양 조언 요청
  Future<NutritionAdviceResult?> getNutritionAdvice({
    Map<String, dynamic>? userProfile,
    required List<Map<String, dynamic>> purchaseHistory,
    Map<String, dynamic>? currentAnalysis,
  }) async {
    try {
      _logger.i('영양 조언 요청 시작');

      final response = await http.post(
        Uri.parse('$_baseUrl/nutrition-advice'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userProfile': userProfile,
          'purchaseHistory': purchaseHistory,
          'currentAnalysis': currentAnalysis,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final result = NutritionAdviceResult.fromJson(data['data']);
          _logger.i('영양 조언 수신 성공');
          return result;
        }
      }

      _logger.e('영양 조언 실패: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      _logger.e('영양 조언 오류: $e');
      return null;
    }
  }
}

/// 영양 조언 결과
class NutritionAdviceResult {
  final OverallAssessment overallAssessment;
  final Map<String, CategoryAnalysis> categoryAnalysis;
  final NutritionBalance nutritionBalance;
  final List<String> personalizedTips;
  final Map<String, FuturePrediction> futurePredictions;
  final ActionPlan actionPlan;

  NutritionAdviceResult({
    required this.overallAssessment,
    required this.categoryAnalysis,
    required this.nutritionBalance,
    required this.personalizedTips,
    required this.futurePredictions,
    required this.actionPlan,
  });

  factory NutritionAdviceResult.fromJson(Map<String, dynamic> json) {
    // 카테고리 분석 파싱
    final categoryMap = <String, CategoryAnalysis>{};
    if (json['categoryAnalysis'] != null) {
      (json['categoryAnalysis'] as Map<String, dynamic>).forEach((key, value) {
        categoryMap[key] = CategoryAnalysis.fromJson(value);
      });
    }

    // 미래 예측 파싱
    final futureMap = <String, FuturePrediction>{};
    if (json['futurePredictions'] != null) {
      (json['futurePredictions'] as Map<String, dynamic>).forEach((key, value) {
        futureMap[key] = FuturePrediction.fromJson(value);
      });
    }

    return NutritionAdviceResult(
      overallAssessment: OverallAssessment.fromJson(json['overallAssessment'] ?? {}),
      categoryAnalysis: categoryMap,
      nutritionBalance: NutritionBalance.fromJson(json['nutritionBalance'] ?? {}),
      personalizedTips: (json['personalizedTips'] as List?)?.cast<String>() ?? [],
      futurePredictions: futureMap,
      actionPlan: ActionPlan.fromJson(json['actionPlan'] ?? {}),
    );
  }
}

class OverallAssessment {
  final int score;
  final String level;
  final String summary;

  OverallAssessment({
    required this.score,
    required this.level,
    required this.summary,
  });

  factory OverallAssessment.fromJson(Map<String, dynamic> json) {
    return OverallAssessment(
      score: (json['score'] as num?)?.toInt() ?? 0,
      level: json['level'] as String? ?? '알 수 없음',
      summary: json['summary'] as String? ?? '',
    );
  }
}

class CategoryAnalysis {
  final int percentage;
  final String assessment;
  final String advice;

  CategoryAnalysis({
    required this.percentage,
    required this.assessment,
    required this.advice,
  });

  factory CategoryAnalysis.fromJson(Map<String, dynamic> json) {
    return CategoryAnalysis(
      percentage: (json['percentage'] as num?)?.toInt() ?? 0,
      assessment: json['assessment'] as String? ?? '',
      advice: json['advice'] as String? ?? '',
    );
  }
}

class NutritionBalance {
  final NutritionStatus sodium;
  final NutritionStatus sugar;
  final NutritionStatus calories;

  NutritionBalance({
    required this.sodium,
    required this.sugar,
    required this.calories,
  });

  factory NutritionBalance.fromJson(Map<String, dynamic> json) {
    return NutritionBalance(
      sodium: NutritionStatus.fromJson(json['sodium'] ?? {}),
      sugar: NutritionStatus.fromJson(json['sugar'] ?? {}),
      calories: NutritionStatus.fromJson(json['calories'] ?? {}),
    );
  }
}

class NutritionStatus {
  final String status;
  final String advice;

  NutritionStatus({
    required this.status,
    required this.advice,
  });

  factory NutritionStatus.fromJson(Map<String, dynamic> json) {
    return NutritionStatus(
      status: json['status'] as String? ?? '알 수 없음',
      advice: json['advice'] as String? ?? '',
    );
  }
}

class FuturePrediction {
  final String riskLevel;
  final int metabolicScore;
  final List<String> mainRisks;
  final String explanation;

  FuturePrediction({
    required this.riskLevel,
    required this.metabolicScore,
    required this.mainRisks,
    required this.explanation,
  });

  factory FuturePrediction.fromJson(Map<String, dynamic> json) {
    return FuturePrediction(
      riskLevel: json['riskLevel'] as String? ?? '알 수 없음',
      metabolicScore: (json['metabolicScore'] as num?)?.toInt() ?? 0,
      mainRisks: (json['mainRisks'] as List?)?.cast<String>() ?? [],
      explanation: json['explanation'] as String? ?? '',
    );
  }
}

class ActionPlan {
  final List<String> immediate;
  final List<String> shortTerm;
  final List<String> longTerm;

  ActionPlan({
    required this.immediate,
    required this.shortTerm,
    required this.longTerm,
  });

  factory ActionPlan.fromJson(Map<String, dynamic> json) {
    return ActionPlan(
      immediate: (json['immediate'] as List?)?.cast<String>() ?? [],
      shortTerm: (json['shortTerm'] as List?)?.cast<String>() ?? [],
      longTerm: (json['longTerm'] as List?)?.cast<String>() ?? [],
    );
  }
}

/// LLM 파싱 결과
class LlmParseResult {
  final List<LlmParsedItem> items;
  final String? store;
  final String? date;
  final int? total;

  LlmParseResult({
    required this.items,
    this.store,
    this.date,
    this.total,
  });

  factory LlmParseResult.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List?)
        ?.map((item) => LlmParsedItem.fromJson(item))
        .toList() ?? [];

    return LlmParseResult(
      items: itemsList,
      store: json['store'] as String?,
      date: json['date'] as String?,
      total: json['total'] as int?,
    );
  }

  @override
  String toString() {
    return 'LlmParseResult(items: ${items.length}, store: $store, date: $date, total: $total)';
  }
}

/// LLM으로 파싱된 상품 항목
class LlmParsedItem {
  final String name;
  final int quantity;
  final int price;

  LlmParsedItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory LlmParsedItem.fromJson(Map<String, dynamic> json) {
    return LlmParsedItem(
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: (json['price'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'LlmParsedItem(name: $name, qty: $quantity, price: $price)';
  }
}
