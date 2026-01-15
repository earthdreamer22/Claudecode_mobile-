import 'package:drift/drift.dart';
import 'user_profile.dart';

/// 영수증 테이블
@DataClassName('ReceiptData')
class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UserProfile, #id)();

  // 영수증 사진 경로
  TextColumn get imagePath => text()();

  // OCR 추출 원본 텍스트
  TextColumn get rawOcrText => text()();

  // 파싱된 항목 개수
  IntColumn get parsedItemCount => integer().withDefault(const Constant(0))();

  // 총액 (선택사항)
  RealColumn get totalAmount => real().nullable()();

  // 영수증 날짜 (영수증에 기재된 날짜)
  DateTimeColumn get receiptDate => dateTime()();

  // 생성 날짜 (앱에서 저장한 날짜)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
