/// 앱 전역 상수 정의
class AppConstants {
  // 앱 정보
  static const String appName = 'ReceiptHealthPredictor';
  static const String appVersion = '1.0.0';

  // 일일 영양소 기준치 (한국 성인 기준)
  static const int dailySodiumLimitMg = 2000; // 나트륨 일일 권장량 (mg)
  static const int dailyCaloriesLimitKcal = 2000; // 칼로리 일일 권장량 (kcal)
  static const double dailySugarLimitG = 50.0; // 당류 일일 권장량 (g)
  static const double dailyFatLimitG = 20.0; // 포화지방 일일 권장량 (g)
  static const double dailyProteinLimitG = 60.0; // 단백질 일일 권장량 (g)
  static const double dailyCarbsLimitG = 324.0; // 탄수화물 일일 권장량 (g)

  // BMI 기준
  static const double bmiUnderweight = 18.5; // 저체중
  static const double bmiNormal = 23.0; // 정상 (한국 기준)
  static const double bmiOverweight = 25.0; // 과체중
  static const double bmiObese = 30.0; // 비만

  // 대사증후군 위험도 점수 기준
  static const double riskScoreSafe = 20.0; // 안전 (0-20)
  static const double riskScoreCaution = 40.0; // 주의 (20-40)
  static const double riskScoreWarning = 60.0; // 경고 (40-60)
  static const double riskScoreDanger = 100.0; // 위험 (60-100)

  // 예측 엔진 가중치 (총 100%)
  static const double weightBmi = 0.20; // 20%
  static const double weightSodium = 0.30; // 30%
  static const double weightSugar = 0.25; // 25%
  static const double weightFat = 0.15; // 15%
  static const double weightFamilyHistory = 0.10; // 10%

  // 식료품 카테고리
  static const List<String> foodCategories = [
    '곡류',
    '육류',
    '채소',
    '과일',
    '유제품',
    '가공식품',
    '음료',
    '기타',
  ];

  // 가족력 질환 목록
  static const List<String> familyHistoryDiseases = [
    '당뇨병',
    '고혈압',
    '심장병',
    '이상지질혈증',
  ];

  // 이미지 처리
  static const int maxImageSizeKb = 5120; // 최대 이미지 크기 (5MB)
  static const int imageQuality = 85; // 이미지 압축 품질 (0-100)
  static const int imageMaxWidth = 1920; // 이미지 최대 너비
  static const int imageMaxHeight = 1920; // 이미지 최대 높이

  // OCR
  static const double ocrConfidenceThreshold = 0.7; // OCR 신뢰도 임계값

  // 데이터베이스
  static const String databaseName = 'rhp_database.db';
  static const int databaseVersion = 1;

  // SharedPreferences Keys
  static const String keyUserId = 'user_id';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyThemeMode = 'theme_mode';

  // 날짜 포맷
  static const String dateFormatDisplay = 'yyyy.MM.dd'; // 표시용
  static const String dateFormatFull = 'yyyy-MM-dd HH:mm:ss'; // 전체
  static const String dateFormatShort = 'MM.dd'; // 짧은 형식

  // 애니메이션 시간
  static const Duration animationDurationShort = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // 페이지 간격
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // 의료 고지문
  static const String medicalDisclaimer = '''
⚠️ 주의사항

이 앱은 의료 진단 도구가 아닙니다.

예측 결과는 참고용이며, 실제 건강 상태 진단 및 치료는 반드시 의료 전문가와 상담하시기 바랍니다.

본 앱의 정보를 바탕으로 한 어떠한 의료적 결정도 전문가의 조언 없이 내리지 마십시오.
''';

  // 온보딩 메시지
  static const String onboardingTitle = '건강한 식습관 관리를 시작하세요';
  static const String onboardingSubtitle = '영수증 촬영으로 간편하게\n대사증후군 위험도를 확인하세요';

  // 에러 메시지
  static const String errorGeneric = '오류가 발생했습니다. 다시 시도해주세요.';
  static const String errorNetwork = '네트워크 연결을 확인해주세요.';
  static const String errorCamera = '카메라를 사용할 수 없습니다.';
  static const String errorOcr = 'OCR 처리에 실패했습니다.';
  static const String errorDatabase = '데이터베이스 오류가 발생했습니다.';
  static const String errorImageTooLarge = '이미지 크기가 너무 큽니다. (최대 5MB)';
  static const String errorNoReceiptDetected = '영수증을 인식할 수 없습니다.';
  static const String errorNoFoodItems = '식료품을 찾을 수 없습니다.';

  // 성공 메시지
  static const String successReceiptSaved = '영수증이 저장되었습니다.';
  static const String successProfileUpdated = '프로필이 업데이트되었습니다.';
  static const String successDataDeleted = '데이터가 삭제되었습니다.';
}
