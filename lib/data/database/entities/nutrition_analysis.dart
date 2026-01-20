import 'package:drift/drift.dart';
import 'user_profile.dart';

/// 영양 분석 결과 테이블 (LLM API 응답 캐싱)
@DataClassName('NutritionAnalysisData')
class NutritionAnalyses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UserProfile, #id)();

  // 분석 날짜 (어느 시점 기준 분석인지)
  DateTimeColumn get analysisDate => dateTime()();

  // 전체 점수 및 레벨
  IntColumn get overallScore => integer()(); // 0-100
  TextColumn get overallLevel => text()(); // 양호, 주의, 경고, 위험
  TextColumn get overallSummary => text()(); // 요약 설명

  // JSON 저장 필드들
  TextColumn get personalizedTips => text()(); // JSON array
  TextColumn get futurePredictions => text()(); // JSON object (1년, 3년, 5년)
  TextColumn get actionPlan => text()(); // JSON object (즉시, 단기, 장기)
  TextColumn get categoryAnalysis => text()(); // JSON array

  // 생성 날짜
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
