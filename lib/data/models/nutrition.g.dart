// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nutrition _$NutritionFromJson(Map<String, dynamic> json) => Nutrition(
      name: json['name'] as String,
      category: json['category'] as String,
      calories: (json['calories'] as num).toInt(),
      sodiumMg: (json['sodium_mg'] as num).toInt(),
      sugarG: (json['sugar_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
      proteinG: (json['protein_g'] as num).toDouble(),
      carbsG: (json['carbs_g'] as num).toDouble(),
    );

Map<String, dynamic> _$NutritionToJson(Nutrition instance) => <String, dynamic>{
      'name': instance.name,
      'category': instance.category,
      'calories': instance.calories,
      'sodium_mg': instance.sodiumMg,
      'sugar_g': instance.sugarG,
      'fat_g': instance.fatG,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
    };
