import 'package:logger/logger.dart';
import '../data/models/nutrition.dart';
import '../data/datasources/nutrition_database.dart';

/// OCR 텍스트에서 식료품 파싱
class FoodParser {
  final _logger = Logger();

  /// OCR 텍스트에서 식료품 항목 추출
  Future<List<ParsedFoodItem>> parseReceiptText(String ocrText) async {
    try {
      _logger.i('식료품 파싱 시작');

      final lines = ocrText.split('\n');
      final parsedItems = <ParsedFoodItem>[];

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // 가격 패턴 감지
        final priceMatch = _extractPrice(line);
        if (priceMatch != null) {
          // 제품명 추출 (가격 앞부분)
          final productName = _extractProductName(line, priceMatch);
          if (productName.isNotEmpty) {
            // 카테고리 자동 분류
            final category = _inferCategory(productName);

            parsedItems.add(ParsedFoodItem(
              name: productName,
              price: priceMatch,
              category: category,
              rawLine: line,
              lineNumber: i + 1,
            ));

            _logger.d('파싱: $productName - ${priceMatch}원 [$category]');
          }
        }
      }

      _logger.i('파싱 완료: ${parsedItems.length}개 항목');
      return parsedItems;
    } catch (e) {
      _logger.e('파싱 실패: $e');
      return [];
    }
  }

  /// 가격 추출 (정규표현식)
  int? _extractPrice(String line) {
    // 패턴: 숫자 + 원, 또는 숫자만 (콤마 포함 가능)
    final patterns = [
      RegExp(r'(\d{1,3}(?:,\d{3})*)\s*원'),
      RegExp(r'(\d{1,3}(?:,\d{3})*)\s*$'),
      RegExp(r'(\d{1,3}(?:,\d{3})*)\s+[^\d]'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final priceStr = match.group(1)?.replaceAll(',', '');
        final price = int.tryParse(priceStr ?? '');
        if (price != null && price >= 100 && price <= 1000000) {
          return price;
        }
      }
    }

    return null;
  }

  /// 제품명 추출
  String _extractProductName(String line, int price) {
    // 가격 앞부분을 제품명으로 간주
    final priceStr = price.toString();
    final priceWithComma = _formatPrice(price);

    // 가격 문자열 위치 찾기
    int priceIndex = line.indexOf(priceWithComma);
    if (priceIndex == -1) {
      priceIndex = line.indexOf(priceStr);
    }
    if (priceIndex == -1) {
      priceIndex = line.lastIndexOf(RegExp(r'\d'));
      if (priceIndex != -1) priceIndex++;
    }

    String productName = '';
    if (priceIndex > 0) {
      productName = line.substring(0, priceIndex).trim();
    } else {
      productName = line.replaceAll(RegExp(r'[\d,원\s]+$'), '').trim();
    }

    // 특수문자 정리
    productName = productName
        .replaceAll(RegExp(r'[*●○▲▼◆◇]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return productName;
  }

  /// 가격 포맷팅 (콤마 추가)
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  /// 카테고리 자동 분류
  String _inferCategory(String productName) {
    final name = productName.toLowerCase();

    // 육류
    if (name.contains('돼지') ||
        name.contains('소고기') ||
        name.contains('닭') ||
        name.contains('삼겹살') ||
        name.contains('불고기') ||
        name.contains('갈비') ||
        name.contains('목살') ||
        name.contains('고기')) {
      return '육류';
    }

    // 채소
    if (name.contains('배추') ||
        name.contains('무') ||
        name.contains('당근') ||
        name.contains('양파') ||
        name.contains('파') ||
        name.contains('마늘') ||
        name.contains('상추') ||
        name.contains('고추') ||
        name.contains('브로콜리') ||
        name.contains('호박') ||
        name.contains('시금치')) {
      return '채소';
    }

    // 과일
    if (name.contains('사과') ||
        name.contains('배') ||
        name.contains('바나나') ||
        name.contains('오렌지') ||
        name.contains('포도') ||
        name.contains('딸기') ||
        name.contains('수박') ||
        name.contains('귤') ||
        name.contains('복숭아')) {
      return '과일';
    }

    // 곡류
    if (name.contains('쌀') ||
        name.contains('밥') ||
        name.contains('빵') ||
        name.contains('국수') ||
        name.contains('면') ||
        name.contains('라면') ||
        name.contains('시리얼') ||
        name.contains('떡')) {
      return '곡류';
    }

    // 유제품
    if (name.contains('우유') ||
        name.contains('치즈') ||
        name.contains('요구르트') ||
        name.contains('요거트') ||
        name.contains('버터') ||
        name.contains('아이스크림')) {
      return '유제품';
    }

    // 음료
    if (name.contains('콜라') ||
        name.contains('사이다') ||
        name.contains('주스') ||
        name.contains('커피') ||
        name.contains('차') ||
        name.contains('물') ||
        name.contains('음료') ||
        name.contains('맥주') ||
        name.contains('소주')) {
      return '음료';
    }

    // 가공식품
    if (name.contains('과자') ||
        name.contains('캔디') ||
        name.contains('초콜릿') ||
        name.contains('라면') ||
        name.contains('햄') ||
        name.contains('소시지') ||
        name.contains('통조림') ||
        name.contains('냉동')) {
      return '가공식품';
    }

    return '기타';
  }

  /// 영양 데이터베이스와 매칭
  Future<List<ParsedFoodItemWithNutrition>> matchWithNutritionDatabase(
      List<ParsedFoodItem> parsedItems) async {
    try {
      _logger.i('영양 데이터 매칭 시작');

      final nutritionDb = await NutritionDatabase.loadNutritionData();
      final results = <ParsedFoodItemWithNutrition>[];

      for (final item in parsedItems) {
        // 제품명으로 영양 데이터 검색
        final matches = nutritionDb.where((nutrition) {
          final nutritionName = nutrition.name.toLowerCase();
          final itemName = item.name.toLowerCase();

          // 키워드 매칭
          return nutritionName.contains(itemName) ||
              itemName.contains(nutritionName) ||
              _hasCommonKeywords(nutritionName, itemName);
        }).toList();

        Nutrition? bestMatch;
        if (matches.isNotEmpty) {
          // 가장 유사한 항목 선택 (길이 차이가 적은 것)
          bestMatch = matches.reduce((a, b) {
            final diffA = (a.name.length - item.name.length).abs();
            final diffB = (b.name.length - item.name.length).abs();
            return diffA < diffB ? a : b;
          });

          _logger.d('매칭: ${item.name} → ${bestMatch.name}');
        } else {
          _logger.w('매칭 실패: ${item.name}');
        }

        results.add(ParsedFoodItemWithNutrition(
          parsedItem: item,
          nutrition: bestMatch,
          matchConfidence: bestMatch != null ? 0.7 : 0.0,
        ));
      }

      _logger.i('매칭 완료: ${results.length}개 항목');
      return results;
    } catch (e) {
      _logger.e('매칭 실패: $e');
      return [];
    }
  }

  /// 공통 키워드 확인
  bool _hasCommonKeywords(String str1, String str2) {
    final keywords1 = str1.split(RegExp(r'\s+')).where((k) => k.length > 1);
    final keywords2 = str2.split(RegExp(r'\s+')).where((k) => k.length > 1);

    for (final k1 in keywords1) {
      for (final k2 in keywords2) {
        if (k1.contains(k2) || k2.contains(k1)) {
          return true;
        }
      }
    }

    return false;
  }
}

/// 파싱된 식료품 항목
class ParsedFoodItem {
  final String name;
  final int price;
  final String category;
  final String rawLine;
  final int lineNumber;

  ParsedFoodItem({
    required this.name,
    required this.price,
    required this.category,
    required this.rawLine,
    required this.lineNumber,
  });

  @override
  String toString() {
    return 'ParsedFoodItem(name: $name, price: $price, category: $category)';
  }
}

/// 영양 정보가 포함된 파싱 항목
class ParsedFoodItemWithNutrition {
  final ParsedFoodItem parsedItem;
  final Nutrition? nutrition;
  final double matchConfidence;

  ParsedFoodItemWithNutrition({
    required this.parsedItem,
    required this.nutrition,
    required this.matchConfidence,
  });

  String get displayName => parsedItem.name;
  int get price => parsedItem.price;
  String get category => parsedItem.category;

  bool get hasNutrition => nutrition != null;

  @override
  String toString() {
    return 'ParsedFoodItemWithNutrition(name: $displayName, nutrition: ${nutrition?.name ?? "없음"})';
  }
}
