import 'package:drift/drift.dart';
import 'receipt.dart';

/// 식료품 항목 테이블
@DataClassName('FoodItemData')
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get receiptId => integer().references(Receipts, #id, onDelete: KeyAction.cascade)();

  // 식료품명
  TextColumn get name => text()();

  // 카테고리: 곡류, 육류, 채소, 과일, 유제품, 가공식품, 음료, 기타
  TextColumn get category => text()();

  // 가격 (원)
  RealColumn get price => real().nullable()();

  // 영양정보
  IntColumn get calories => integer().nullable()(); // 칼로리(kcal)
  IntColumn get sodiumMg => integer().nullable()(); // 나트륨(mg)
  RealColumn get sugarG => real().nullable()(); // 당류(g)
  RealColumn get fatG => real().nullable()(); // 지방(g)
  RealColumn get proteinG => real().nullable()(); // 단백질(g)
  RealColumn get carbsG => real().nullable()(); // 탄수화물(g)

  // 수량
  IntColumn get quantity => integer().withDefault(const Constant(1))();

  // 추가된 날짜
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}
