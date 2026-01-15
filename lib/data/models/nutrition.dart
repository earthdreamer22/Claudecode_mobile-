import 'package:json_annotation/json_annotation.dart';

part 'nutrition.g.dart';

/// 식료품 영양정보 모델
@JsonSerializable()
class Nutrition {
  final String name; // 식료품명
  final String category; // 카테고리
  final int calories; // 칼로리(kcal)
  @JsonKey(name: 'sodium_mg')
  final int sodiumMg; // 나트륨(mg)
  @JsonKey(name: 'sugar_g')
  final double sugarG; // 당류(g)
  @JsonKey(name: 'fat_g')
  final double fatG; // 지방(g)
  @JsonKey(name: 'protein_g')
  final double proteinG; // 단백질(g)
  @JsonKey(name: 'carbs_g')
  final double carbsG; // 탄수화물(g)

  Nutrition({
    required this.name,
    required this.category,
    required this.calories,
    required this.sodiumMg,
    required this.sugarG,
    required this.fatG,
    required this.proteinG,
    required this.carbsG,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionToJson(this);

  /// 복사 생성자
  Nutrition copyWith({
    String? name,
    String? category,
    int? calories,
    int? sodiumMg,
    double? sugarG,
    double? fatG,
    double? proteinG,
    double? carbsG,
  }) {
    return Nutrition(
      name: name ?? this.name,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      sodiumMg: sodiumMg ?? this.sodiumMg,
      sugarG: sugarG ?? this.sugarG,
      fatG: fatG ?? this.fatG,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
    );
  }

  @override
  String toString() {
    return 'Nutrition(name: $name, category: $category, calories: $calories, '
        'sodiumMg: $sodiumMg, sugarG: $sugarG, fatG: $fatG)';
  }
}
