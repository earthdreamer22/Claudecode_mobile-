/// 파싱된 식료품 데이터 (영수증에서 추출)
class FoodData {
  final String name; // 상품명
  final String category; // 자동 분류된 카테고리
  final int? price; // 가격 (선택사항)

  // 영양정보 (DB 조회 후 채워짐)
  int? calories;
  int? sodiumMg;
  double? sugarG;
  double? fatG;
  double? proteinG;
  double? carbsG;

  int quantity; // 수량

  FoodData({
    required this.name,
    required this.category,
    this.price,
    this.calories,
    this.sodiumMg,
    this.sugarG,
    this.fatG,
    this.proteinG,
    this.carbsG,
    this.quantity = 1,
  });

  /// 영양정보 설정
  void setNutrition({
    required int calories,
    required int sodiumMg,
    required double sugarG,
    required double fatG,
    required double proteinG,
    required double carbsG,
  }) {
    this.calories = calories;
    this.sodiumMg = sodiumMg;
    this.sugarG = sugarG;
    this.fatG = fatG;
    this.proteinG = proteinG;
    this.carbsG = carbsG;
  }

  /// 영양정보 설정 여부 확인
  bool get hasNutrition =>
      calories != null &&
      sodiumMg != null &&
      sugarG != null &&
      fatG != null;

  /// 복사 생성자
  FoodData copyWith({
    String? name,
    String? category,
    int? price,
    int? calories,
    int? sodiumMg,
    double? sugarG,
    double? fatG,
    double? proteinG,
    double? carbsG,
    int? quantity,
  }) {
    return FoodData(
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      calories: calories ?? this.calories,
      sodiumMg: sodiumMg ?? this.sodiumMg,
      sugarG: sugarG ?? this.sugarG,
      fatG: fatG ?? this.fatG,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'FoodData(name: $name, category: $category, price: $price, '
        'hasNutrition: $hasNutrition, quantity: $quantity)';
  }
}
