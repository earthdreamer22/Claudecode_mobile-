import 'package:drift/drift.dart';
import 'user_profile.dart';

/// 영양 분석 결과 테이블 (LLM API 응답 캐싱) - v3
@DataClassName('NutritionAnalysisData')
class NutritionAnalyses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UserProfile, #id)();

  // 분석 날짜
  DateTimeColumn get analysisDate => dateTime()();

  // 식습관 캐릭터 (JSON)
  TextColumn get dietCharacter => text()();

  // 구매 패턴 인사이트 (JSON array)
  TextColumn get purchasePatterns => text()();

  // 결핍 경고 (JSON array)
  TextColumn get deficiencyWarnings => text()();

  // 미래 건강 시나리오 (JSON array)
  TextColumn get futureScenarios => text()();

  // 추세 비교 (JSON, nullable)
  TextColumn get trendComparison => text().nullable()();

  // 생성 날짜
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
