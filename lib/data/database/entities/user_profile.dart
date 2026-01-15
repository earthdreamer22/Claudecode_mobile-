import 'package:drift/drift.dart';

/// 사용자 프로필 테이블
@DataClassName('UserProfileData')
class UserProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get age => integer()();
  TextColumn get gender => text()(); // 'M', 'F'
  RealColumn get height => real()(); // cm
  RealColumn get weight => real()(); // kg

  // JSON 형태로 저장: {"diabetes": false, "hypertension": true, ...}
  TextColumn get familyHistory => text().withDefault(const Constant('{}'))();

  // JSON 형태로 저장
  TextColumn get existingConditions => text().withDefault(const Constant('{}'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
