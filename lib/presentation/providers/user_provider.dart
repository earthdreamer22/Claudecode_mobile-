import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/app_database.dart';
import '../../data/repositories/user_repository.dart';
import '../../config/constants.dart';
import 'database_provider.dart';

/// 현재 사용자 프로필 StateNotifier
class UserNotifier extends StateNotifier<AsyncValue<UserProfileData?>> {
  final UserRepository _userRepository;
  final SharedPreferences _prefs;

  UserNotifier(this._userRepository, this._prefs)
      : super(const AsyncValue.loading()) {
    _loadUser();
  }

  /// 사용자 프로필 로드
  Future<void> _loadUser() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _userRepository.getFirstProfile();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// 프로필 생성
  Future<bool> createProfile({
    required int age,
    required String gender,
    required double height,
    required double weight,
    Map<String, bool>? familyHistory,
    Map<String, bool>? existingConditions,
  }) async {
    try {
      final userId = await _userRepository.createProfile(
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        familyHistory: familyHistory,
        existingConditions: existingConditions,
      );

      // SharedPreferences에 userId 저장
      await _prefs.setInt(AppConstants.keyUserId, userId);
      await _prefs.setBool(AppConstants.keyOnboardingCompleted, true);

      // 프로필 다시 로드
      await _loadUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 프로필 업데이트
  Future<bool> updateProfile({
    required int userId,
    int? age,
    String? gender,
    double? height,
    double? weight,
    Map<String, bool>? familyHistory,
    Map<String, bool>? existingConditions,
  }) async {
    try {
      final success = await _userRepository.updateProfile(
        userId: userId,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        familyHistory: familyHistory,
        existingConditions: existingConditions,
      );

      if (success) {
        await _loadUser();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  /// BMI 계산
  double calculateBMI(double weight, double height) {
    return _userRepository.calculateBMI(weight, height);
  }

  /// 프로필 새로고침
  Future<void> refresh() async {
    await _loadUser();
  }
}

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized');
});

/// UserNotifier Provider
final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserProfileData?>>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserNotifier(userRepository, prefs);
});

/// 온보딩 완료 여부 Provider
final onboardingCompletedProvider = Provider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
});
