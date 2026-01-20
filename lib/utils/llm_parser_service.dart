import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// LLM API를 통한 영수증 파싱 서비스
class LlmParserService {
  final _logger = Logger();

  // Vercel 배포 URL
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
