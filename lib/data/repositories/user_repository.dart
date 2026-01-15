import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'dart:convert';

/// 사용자 프로필 Repository
class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  /// 사용자 프로필 생성
  Future<int> createProfile({
    required int age,
    required String gender,
    required double height,
    required double weight,
    Map<String, bool>? familyHistory,
    Map<String, bool>? existingConditions,
  }) async {
    return await _db.createUserProfile(
      UserProfileCompanion.insert(
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        familyHistory: Value(json.encode(familyHistory ?? {})),
        existingConditions: Value(json.encode(existingConditions ?? {})),
      ),
    );
  }

  /// 사용자 프로필 조회
  Future<UserProfileData?> getProfile(int userId) async {
    return await _db.getUserProfile(userId);
  }

  /// 첫 번째 사용자 프로필 조회 (단일 사용자 앱)
  Future<UserProfileData?> getFirstProfile() async {
    return await _db.getFirstUserProfile();
  }

  /// 사용자 프로필 업데이트
  Future<bool> updateProfile({
    required int userId,
    int? age,
    String? gender,
    double? height,
    double? weight,
    Map<String, bool>? familyHistory,
    Map<String, bool>? existingConditions,
  }) async {
    final existing = await getProfile(userId);
    if (existing == null) return false;

    final updated = existing.copyWith(
      age: age ?? existing.age,
      gender: gender ?? existing.gender,
      height: height ?? existing.height,
      weight: weight ?? existing.weight,
      familyHistory:
          familyHistory != null ? json.encode(familyHistory) : existing.familyHistory,
      existingConditions: existingConditions != null
          ? json.encode(existingConditions)
          : existing.existingConditions,
      updatedAt: DateTime.now(),
    );

    return await _db.updateUserProfile(updated);
  }

  /// BMI 계산
  double calculateBMI(double weight, double height) {
    final heightM = height / 100; // cm to m
    return weight / (heightM * heightM);
  }

  /// 가족력 파싱
  Map<String, bool> parseFamilyHistory(String jsonString) {
    try {
      final decoded = json.decode(jsonString) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      return {};
    }
  }

  /// 기저질환 파싱
  Map<String, bool> parseExistingConditions(String jsonString) {
    try {
      final decoded = json.decode(jsonString) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      return {};
    }
  }
}
