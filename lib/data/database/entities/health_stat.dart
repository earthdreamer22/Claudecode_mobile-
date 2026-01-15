import 'package:drift/drift.dart';
import 'user_profile.dart';

/// 일별 건강 통계 테이블
@DataClassName('HealthStatData')
class HealthStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UserProfile, #id)();

  // 날짜 (일별 기준)
  DateTimeColumn get date => dateTime()();

  // 일일 영양소 합계
  IntColumn get totalSodium => integer(); // 일일 나트륨 합계(mg)
  IntColumn get totalCalories => integer(); // 일일 칼로리 합계(kcal)
  RealColumn get totalSugar => real(); // 일일 당류 합계(g)
  RealColumn get totalFat => real(); // 일일 지방 합계(g)
  RealColumn get totalProtein => real(); // 일일 단백질 합계(g)
  RealColumn get totalCarbs => real(); // 일일 탄수화물 합계(g)

  // 대사증후군 위험도 점수 (0-100)
  RealColumn get metabolicScore => real();

  // 위험 레벨: 'SAFE', 'CAUTION', 'WARNING', 'DANGER'
  TextColumn get riskLevel => text();

  // 생성 날짜
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // 복합 유니크 인덱스: userId + date (일별 조회 최적화)
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {userId, date}
      ];
}
