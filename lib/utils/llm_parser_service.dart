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

/// 영양 조언 결과 (v2 - 창의적 분석)
class NutritionAdviceResult {
  final DietCharacter dietCharacter;
  final List<PurchasePatternInsight> purchasePatterns;
  final List<DeficiencyWarning> deficiencyWarnings;
  final List<FutureHealthScenario> futureScenarios;

  NutritionAdviceResult({
    required this.dietCharacter,
    required this.purchasePatterns,
    required this.deficiencyWarnings,
    required this.futureScenarios,
  });

  factory NutritionAdviceResult.fromJson(Map<String, dynamic> json) {
    return NutritionAdviceResult(
      dietCharacter: DietCharacter.fromJson(json['dietCharacter'] ?? {}),
      purchasePatterns: (json['purchasePatterns'] as List?)
          ?.map((e) => PurchasePatternInsight.fromJson(e))
          .toList() ?? [],
      deficiencyWarnings: (json['deficiencyWarnings'] as List?)
          ?.map((e) => DeficiencyWarning.fromJson(e))
          .toList() ?? [],
      futureScenarios: (json['futureScenarios'] as List?)
          ?.map((e) => FutureHealthScenario.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dietCharacter': dietCharacter.toJson(),
      'purchasePatterns': purchasePatterns.map((e) => e.toJson()).toList(),
      'deficiencyWarnings': deficiencyWarnings.map((e) => e.toJson()).toList(),
      'futureScenarios': futureScenarios.map((e) => e.toJson()).toList(),
    };
  }
}

/// 식습관 캐릭터
class DietCharacter {
  final String typeName;
  final String emoji;
  final List<String> traits;
  final String description;
  final String riskSummary;

  DietCharacter({
    required this.typeName,
    required this.emoji,
    required this.traits,
    required this.description,
    required this.riskSummary,
  });

  factory DietCharacter.fromJson(Map<String, dynamic> json) {
    return DietCharacter(
      typeName: json['typeName'] as String? ?? '분석 중',
      emoji: json['emoji'] as String? ?? '🍽️',
      traits: (json['traits'] as List?)?.cast<String>() ?? [],
      description: json['description'] as String? ?? '',
      riskSummary: json['riskSummary'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'typeName': typeName,
    'emoji': emoji,
    'traits': traits,
    'description': description,
    'riskSummary': riskSummary,
  };
}

/// 구매 패턴 인사이트
class PurchasePatternInsight {
  final String pattern;
  final String insight;
  final String impact;

  PurchasePatternInsight({
    required this.pattern,
    required this.insight,
    required this.impact,
  });

  factory PurchasePatternInsight.fromJson(Map<String, dynamic> json) {
    return PurchasePatternInsight(
      pattern: json['pattern'] as String? ?? '',
      insight: json['insight'] as String? ?? '',
      impact: json['impact'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'pattern': pattern,
    'insight': insight,
    'impact': impact,
  };
}

/// 결핍 경고
class DeficiencyWarning {
  final String category;
  final String nutrient;
  final String warning;
  final String recommendation;

  DeficiencyWarning({
    required this.category,
    required this.nutrient,
    required this.warning,
    required this.recommendation,
  });

  factory DeficiencyWarning.fromJson(Map<String, dynamic> json) {
    return DeficiencyWarning(
      category: json['category'] as String? ?? '',
      nutrient: json['nutrient'] as String? ?? '',
      warning: json['warning'] as String? ?? '',
      recommendation: json['recommendation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'nutrient': nutrient,
    'warning': warning,
    'recommendation': recommendation,
  };
}

/// 미래 건강 시나리오
class FutureHealthScenario {
  final int targetAge;
  final String condition;
  final int probabilityPercent;
  final String explanation;
  final String preventionTip;

  FutureHealthScenario({
    required this.targetAge,
    required this.condition,
    required this.probabilityPercent,
    required this.explanation,
    required this.preventionTip,
  });

  factory FutureHealthScenario.fromJson(Map<String, dynamic> json) {
    return FutureHealthScenario(
      targetAge: (json['targetAge'] as num?)?.toInt() ?? 0,
      condition: json['condition'] as String? ?? '',
      probabilityPercent: (json['probabilityPercent'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String? ?? '',
      preventionTip: json['preventionTip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'targetAge': targetAge,
    'condition': condition,
    'probabilityPercent': probabilityPercent,
    'explanation': explanation,
    'preventionTip': preventionTip,
  };
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
