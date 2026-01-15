# 📱 ReceiptHealthPredictor (RHP) - 완전 프로젝트 명세서

**프로젝트 목표**: 마트 영수증 기반 만성질환(대사증후군) 위험도 예측 Flutter 앱  
**플랫폼**: Android (API 35+ - Google Play Store 프로덕션 기준)  
**개발 언어**: Dart + Flutter 3.x  
**완성도**: MVP (최소 기능 완성품)

---

## 📊 1. 프로젝트 구조

```
receipt_health_predictor/
├── android/                          # Android 네이티브 설정
├── ios/                             # iOS (향후)
├── lib/
│   ├── main.dart                    # 앱 진입점
│   ├── config/
│   │   ├── theme.dart               # Material 3 테마
│   │   └── constants.dart           # 상수값 (나트륨 기준치, BMI 등)
│   ├── data/
│   │   ├── database/
│   │   │   ├── app_database.dart    # Drift 데이터베이스 설정
│   │   │   └── entities/
│   │   │       ├── user_profile.dart
│   │   │       ├── receipt.dart
│   │   │       ├── food_item.dart
│   │   │       └── health_stat.dart
│   │   ├── models/
│   │   │   ├── nutrition.dart       # 영양정보 데이터 모델
│   │   │   ├── food_data.dart       # 식료품 정보 모델
│   │   │   └── prediction_result.dart # 예측 결과 모델
│   │   ├── repositories/
│   │   │   ├── user_repository.dart
│   │   │   ├── receipt_repository.dart
│   │   │   └── health_repository.dart
│   │   └── datasources/
│   │       ├── nutrition_database.dart # 임베드 식료품 DB (JSON)
│   │       └── prediction_engine.dart  # 규칙 기반 예측 알고리즘
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user.dart
│   │   │   ├── receipt.dart
│   │   │   └── food_item.dart
│   │   └── usecases/
│   │       ├── process_receipt_usecase.dart
│   │       ├── calculate_prediction_usecase.dart
│   │       └── get_health_stats_usecase.dart
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── splash_screen.dart      # 시작 화면
│   │   │   ├── onboarding_screen.dart  # 프로필 입력
│   │   │   ├── home_screen.dart        # 메인 화면
│   │   │   ├── camera_screen.dart      # 영수증 촬영
│   │   │   ├── receipt_review_screen.dart # 영수증 검증
│   │   │   ├── receipt_list_screen.dart   # 영수증 목록
│   │   │   └── prediction_screen.dart  # 예측 결과
│   │   ├── widgets/
│   │   │   ├── food_item_card.dart
│   │   │   ├── prediction_chart.dart
│   │   │   ├── nutrition_indicator.dart
│   │   │   ├── bottom_nav_bar.dart
│   │   │   └── risk_gauge.dart
│   │   └── providers/
│   │       ├── user_provider.dart
│   │       ├── receipt_provider.dart
│   │       └── prediction_provider.dart
│   └── utils/
│       ├── ocr_service.dart            # Google ML Kit 래퍼
│       ├── food_parser.dart            # 정규표현식 기반 파싱
│       ├── image_processor.dart        # 이미지 전처리
│       ├── validation.dart             # 유효성 검사
│       └── logger.dart                 # 디버깅 로그
├── assets/
│   ├── nutrition_data.json             # 기본 식료품 영양정보 DB (200개)
│   ├── images/                         # 아이콘, 배경
│   └── translations/                   # 추후 다국어
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 📦 2. 필수 의존성 (pubspec.yaml)

```yaml
name: receipt_health_predictor
description: 영수증 기반 만성질환 예측 앱
version: 1.0.0+1
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.13.0'

# Android 프로덕션 배포 기준 (Google Play Store 2024년 이후)
# minSdkVersion: 35 (build.gradle 에서 설정)
# targetSdkVersion: 35
# compileSdkVersion: 35

dependencies:
  flutter:
    sdk: flutter
  
  # 카메라 & 이미지 처리
  camera: ^0.10.5
  image_picker: ^1.0.4
  image: ^4.0.0
  path_provider: ^2.1.0
  
  # OCR - Google ML Kit
  google_ml_kit: ^0.16.0
  
  # 로컬 데이터베이스
  sqflite: ^2.3.0
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0
  
  # 상태 관리
  riverpod: ^2.4.0
  flutter_riverpod: ^2.4.0
  
  # UI & Charts
  fl_chart: ^0.65.0                  # 라인/원형 차트
  percent_indicator: ^4.1.0          # 프로그레스 바
  intl: ^0.19.0                      # 국제화 (날짜 포맷)
  
  # 유틸리티
  uuid: ^4.0.0
  json_annotation: ^4.8.0
  
  # 로깅
  logger: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  drift_dev: ^2.14.0
  json_serializable: ^6.7.0

flutter:
  uses-material-design: true
  assets:
    - assets/nutrition_data.json
```

---

## 🗄️ 3. 데이터베이스 스키마 (Drift)

### 3.1 User Profile 엔티티

```dart
@DataClassName("UserProfileData")
class UserProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get age => integer()();
  TextColumn get gender => text()(); // 'M', 'F'
  RealColumn get height => real()(); // cm
  RealColumn get weight => real()(); // kg
  TextColumn get familyHistory => text()(); // JSON: {"diabetes": false, "hypertension": true, ...}
  TextColumn get existingConditions => text()(); // JSON
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 3.2 Receipt 엔티티

```dart
@DataClassName("ReceiptData")
class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UserProfile, #id)();
  TextColumn get imagePath => text()(); // 영수증 사진 경로
  TextColumn get rawOcrText => text()(); // OCR 추출 원본 텍스트
  IntColumn get parsedItemCount => integer().withDefault(const Constant(0))();
  RealColumn get totalAmount => real().nullable()(); // 총액
  DateTimeColumn get receiptDate => dateTime()(); // 영수증 날짜
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 3.3 Food Item 엔티티

```dart
@DataClassName("FoodItemData")
class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get receiptId => integer().references(Receipts, #id)();
  TextColumn get name => text()(); // 식료품명
  TextColumn get category => text()(); // 곡류, 육류, 채소, 과일, 유제품, 가공식품, 음료
  IntColumn get calories => integer().nullable()();
  IntColumn get sodiumMg => integer().nullable()(); // 나트륨(mg)
  RealColumn get sugarG => real().nullable()(); // 당류(g)
  RealColumn get fatG => real().nullable()(); // 지방(g)
  RealColumn get proteinG => real().nullable()(); // 단백질(g)
  RealColumn get carbsG => real().nullable()(); // 탄수화물(g)
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 3.4 Health Stat 엔티티

```dart
@DataClassName("HealthStatData")
class HealthStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(UserProfile, #id)();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalSodiumDailyMg => integer(); // 일일 나트륨 합계
  IntColumn get totalCaloriesDaily => integer(); // 일일 칼로리 합계
  RealColumn get totalSugarDailyG => real(); // 일일 당류 합계
  RealColumn get metabolicScore => real(); // 대사증후군 위험도 (0-100)
  TextColumn get riskLevel => text(); // 'SAFE', 'CAUTION', 'WARNING', 'DANGER'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column<Object>> get primaryKey => {userId, date};
}
```

---

## 🎯 4. 핵심 기능 명세

### 4.1 온보딩 (사용자 프로필 입력)

**화면: OnboardingScreen**

입력 항목:
- 나이 (18-100)
- 성별 (남성/여성)
- 키 (cm)
- 현재 몸무게 (kg)
- 가족력 체크박스:
  - [ ] 당뇨병
  - [ ] 고혈압
  - [ ] 심장병
  - [ ] 이상지질혈증
- 현재 기저질환: 있음/없음

검증:
- 모든 필수 항목 입력 확인
- BMI 자동 계산 (weight / (height/100)^2)
- 저장 후 HomeScreen으로 이동

저장:
- UserProfile 테이블에 저장
- SharedPreferences에 userId 저장 (온보딩 표시)

---

### 4.2 카메라 & OCR

**화면: CameraScreen**

기능:
1. 실시간 카메라 피드 표시
2. 영수증 영역 가이드 (흰 테두리)
3. "촬영" 버튼 클릭시 사진 저장
4. "갤러리에서 선택" 옵션

**서비스: ocr_service.dart**

```dart
class OcrService {
  Future<String> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognisedText = await textRecognizer.processImage(inputImage);
      return recognisedText.text;
    } finally {
      textRecognizer.close();
    }
  }
}
```

**이미지 전처리: image_processor.dart**

```dart
class ImageProcessor {
  // 1. 자동 회전 감지
  Future<File> autoRotateImage(File imageFile) async { }
  
  // 2. 명도/콘트라스트 조정 (CLAHE)
  Future<File> enhanceContrast(File imageFile) async { }
  
  // 3. 영수증 영역 감지 (4점 변환)
  Future<File> detectAndCropReceipt(File imageFile) async { }
  
  // 4. 리사이징
  Future<File> resizeOptimal(File imageFile) async { }
}
```

워크플로우:
```
사진 촬영 → 이미지 전처리 → OCR 처리 → 원본 텍스트 저장 → ReceiptReviewScreen 이동
```

---

### 4.3 식료품 파싱 & 검증

**서비스: food_parser.dart**

파싱 로직:
```dart
class FoodParser {
  List<FoodItem> parseReceipt(String ocrText) {
    // 1. 줄 단위로 분리
    List<String> lines = ocrText.split('\n');
    
    // 2. 상품명 + 가격 패턴 인식
    // 예: "돼지불고기 (500g)    15,900"
    //     "물 (1.5L)          1,500"
    RegExp pattern = RegExp(
      r'(.+?)\s+(\d{1,3}(?:,\d{3})*|\d+)(?:\s*원)?$',
      multiLine: true
    );
    
    // 3. 매칭된 라인 추출
    final matches = pattern.allMatches(ocrText);
    List<FoodItem> items = [];
    
    for (var match in matches) {
      String name = match.group(1)?.trim() ?? '';
      if (name.isNotEmpty && name.length > 2) {
        items.add(FoodItem(
          name: name,
          category: _inferCategory(name), // 자동 분류
        ));
      }
    }
    
    return items;
  }
  
  String _inferCategory(String name) {
    // 키워드 기반 자동 분류
    if (name.contains('쌀') || name.contains('밥')) return '곡류';
    if (name.contains('소고기') || name.contains('돼지') || name.contains('닭')) return '육류';
    if (name.contains('깻잎') || name.contains('상추') || name.contains('김치')) return '채소';
    // ... 기타
    return '기타';
  }
}
```

**화면: ReceiptReviewScreen**

표시 항목:
- 파싱된 식료품 리스트 (카드형)
- 각 카드에: 상품명, 카테고리, 영양정보(있으면)
- 하단: 추가/삭제/수정 버튼

검증 플로우:
```
1. 파싱된 항목 표시
2. 사용자가 항목 추가/삭제/카테고리 변경
3. 영양정보 DB에서 자동 조회
4. "저장" 클릭 → DB에 저장
5. HomeScreen으로 돌아가기
```

---

### 4.4 식료품 영양정보 DB

**파일: assets/nutrition_data.json**

```json
{
  "foods": [
    {
      "name": "돼지불고기 (100g)",
      "category": "육류",
      "calories": 384,
      "sodium_mg": 58,
      "sugar_g": 0,
      "fat_g": 35,
      "protein_g": 20,
      "carbs_g": 0
    },
    {
      "name": "김치 (100g)",
      "category": "채소",
      "calories": 20,
      "sodium_mg": 600,
      "sugar_g": 1,
      "fat_g": 0.5,
      "protein_g": 1,
      "carbs_g": 4
    },
    {
      "name": "흰쌀 (1공기, 150g)",
      "category": "곡류",
      "calories": 195,
      "sodium_mg": 5,
      "sugar_g": 0,
      "fat_g": 0.3,
      "protein_g": 4,
      "carbs_g": 43
    },
    {
      "name": "계란 (1개)",
      "category": "유제품",
      "calories": 155,
      "sodium_mg": 124,
      "sugar_g": 1,
      "fat_g": 11,
      "protein_g": 13,
      "carbs_g": 1
    },
    {
      "name": "콜라 (250ml)",
      "category": "음료",
      "calories": 105,
      "sodium_mg": 20,
      "sugar_g": 26,
      "fat_g": 0,
      "protein_g": 0,
      "carbs_g": 26
    },
    {
      "name": "라면 (끓인 것, 1인분)",
      "category": "가공식품",
      "calories": 350,
      "sodium_mg": 1800,
      "sugar_g": 0.5,
      "fat_g": 12,
      "protein_g": 8,
      "carbs_g": 55
    }
    // ... 초기 200개 식료품
  ]
}
```

로딩:
```dart
class NutritionDatabase {
  static Future<List<Nutrition>> loadNutritionData() async {
    final jsonString = await rootBundle.loadString('assets/nutrition_data.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final foods = data['foods'] as List<dynamic>;
    return foods.map((f) => Nutrition.fromJson(f)).toList();
  }
  
  static Nutrition? searchByName(String name) {
    // 정확 매칭 + 부분 매칭 (유사도)
  }
}
```

---

### 4.5 규칙 기반 예측 엔진

**파일: prediction_engine.dart**

**대사증후군 진단 기준** (한국 가이드라인)
- 복부 비만: 남성 허리둘레 90cm+, 여성 85cm+ (BMI로 추정)
- 혈압: 수축기 130 이상 (추정값 사용)
- 혈당: 공복혈당 100 이상 (탄수화물+당류로 추정)
- 중성지방: 150 이상 (지방 섭취로 추정)
- HDL: 남성 40 이하, 여성 50 이하 (추정)

**점수 계산 로직:**

```dart
class PredictionEngine {
  /// 일일 대사증후군 위험도 계산 (0-100)
  static double calculateMetabolicScore({
    required UserProfile user,
    required List<FoodItem> dailyFoods,
  }) {
    double baseScore = 0;
    
    // 1. BMI 기여도 (20%)
    double bmi = calculateBMI(user.weight, user.height);
    double bmiScore = (bmi / 25) * 20; // BMI 25 기준
    if (bmiScore > 20) bmiScore = 20;
    baseScore += bmiScore;
    
    // 2. 나트륨 기여도 (30%)
    int totalSodium = dailyFoods.fold(0, (sum, item) => sum + (item.sodiumMg ?? 0));
    double sodiumScore = (totalSodium / 2000) * 30; // 일일 기준 2000mg
    if (sodiumScore > 30) sodiumScore = 30;
    baseScore += sodiumScore;
    
    // 3. 당류 기여도 (25%)
    double totalSugar = dailyFoods.fold(0.0, (sum, item) => sum + (item.sugarG ?? 0));
    double sugarScore = (totalSugar / 50) * 25; // 일일 기준 50g
    if (sugarScore > 25) sugarScore = 25;
    baseScore += sugarScore;
    
    // 4. 포화지방 기여도 (15%)
    double totalFat = dailyFoods.fold(0.0, (sum, item) => sum + (item.fatG ?? 0));
    double fatScore = (totalFat / 20) * 15; // 일일 기준 20g
    if (fatScore > 15) fatScore = 15;
    baseScore += fatScore;
    
    // 5. 가족력 기여도 (10%)
    int familyRiskCount = _countFamilyRisks(user.familyHistory);
    double familyScore = familyRiskCount * 5; // 최대 20, 상한 10
    if (familyScore > 10) familyScore = 10;
    baseScore += familyScore;
    
    return baseScore.clamp(0, 100);
  }
  
  /// 월별 데이터로 연도별 예측
  static Map<String, double> predictFutureRisk({
    required double currentScore,
    required List<double> monthlyScores, // 최근 12개월 점수
  }) {
    // 월별 증감 추이 계산
    double avgMonthlyChange = 0;
    if (monthlyScores.length > 1) {
      double totalChange = monthlyScores.last - monthlyScores.first;
      avgMonthlyChange = totalChange / monthlyScores.length;
    }
    
    return {
      '1year': (currentScore + (avgMonthlyChange * 12)).clamp(0, 100),
      '3years': (currentScore + (avgMonthlyChange * 36)).clamp(0, 100),
      '5years': (currentScore + (avgMonthlyChange * 60)).clamp(0, 100),
    };
  }
  
  /// 위험 요인 텍스트 생성
  static List<String> generateRecommendations({
    required UserProfile user,
    required List<FoodItem> dailyFoods,
    required double metabolicScore,
  }) {
    List<String> recommendations = [];
    
    int totalSodium = dailyFoods.fold(0, (sum, item) => sum + (item.sodiumMg ?? 0));
    if (totalSodium > 2000) {
      recommendations.add('일일 나트륨이 2000mg을 초과했습니다. 가공식품과 염분 섭취를 줄여주세요.');
    }
    
    double totalSugar = dailyFoods.fold(0.0, (sum, item) => sum + (item.sugarG ?? 0));
    if (totalSugar > 50) {
      recommendations.add('과다 당류 섭취가 감지되었습니다. 음료 선택시 무가당 제품을 권장합니다.');
    }
    
    double bmi = calculateBMI(user.weight, user.height);
    if (bmi > 25) {
      recommendations.add('BMI가 과체중 범위입니다. 운동과 함께 칼로리 관리를 권장합니다.');
    }
    
    if (metabolicScore < 30) {
      recommendations.add('건강한 식단을 유지 중입니다. 계속 진행해주세요!');
    }
    
    return recommendations;
  }
  
  static double calculateBMI(double weight, double height) {
    double heightM = height / 100;
    return weight / (heightM * heightM);
  }
  
  static int _countFamilyRisks(Map<String, dynamic> familyHistory) {
    return familyHistory.values.where((v) => v == true).length;
  }
}
```

**위험도 레벨 분류:**
```dart
enum RiskLevel { safe, caution, warning, danger }

RiskLevel getRiskLevel(double score) {
  if (score < 20) return RiskLevel.safe;
  if (score < 40) return RiskLevel.caution;
  if (score < 60) return RiskLevel.warning;
  return RiskLevel.danger;
}

Color getRiskColor(RiskLevel level) {
  return {
    RiskLevel.safe: Colors.green,
    RiskLevel.caution: Colors.yellow,
    RiskLevel.warning: Colors.orange,
    RiskLevel.danger: Colors.red,
  }[level]!;
}
```

---

### 4.6 UI 화면 상세

#### **HomeScreen**

레이아웃:
```
┌─────────────────────────────────┐
│  안녕하세요, [사용자명]님           │
│  현재 BMI: 25.3kg/m²             │
└─────────────────────────────────┘

┌────── 대사증후군 위험도 ──────┐
│                               │
│    ┌─────────────┐            │
│    │   위험도    │ 35%        │
│    │   (원형)    │ (주황색)   │
│    └─────────────┘            │
│                               │
│  위험 수준: 경고(⚠️)          │
└───────────────────────────────┘

┌─ 최근 영수증 ─────────────────┐
│ 2024.1.14 • 5개 항목 • 32,500원 │
│ 칼로리: 2,100kcal              │
│ 나트륨: 2,450mg ⚠️ 초과       │
└───────────────────────────────┘

┌─ 주간 영양소 요약 ────────────┐
│ 칼로리: 15,200 / 14,000 kcal   │
│ 나트륨: 12,400 / 14,000 mg     │
│ 당류:   250 / 350 g            │
└───────────────────────────────┘

┌─────────────────────────────────┐
│ 🎯 예측 분석 보기               │
│ 📷 새 영수증 촬영               │
└─────────────────────────────────┘

[네비게이션 바: 홈 | 영수증 | 예측]
```

#### **PredictionScreen**

레이아웃:
```
┌─────────────────────────────────┐
│ 대사증후군 위험도 예측            │
└─────────────────────────────────┘

┌───── 현재 위험도 ────┐
│                     │
│   ┌─────────┐       │
│   │  35%    │       │
│   │ (주황색) │       │
│   └─────────┘       │
│                     │
│ 위험 수준: ⚠️ 경고   │
└─────────────────────┘

┌─ 연도별 예측 그래프 ──┐
│                      │
│  100%│              ╱│
│      │            ╱  │
│   50%│──────────╱────│
│      │  ╱───────      │
│    0%│╱────────────── │
│      └────────────────│
│      1yr  3yr   5yr   │
│      35%  42%   50%   │
└──────────────────────┘

┌─ 위험 요인 분석 ──────┐
│                      │
│ ⚠️ 과다 나트륨 섭취   │
│    일일 2,450mg      │
│    (기준: 2,000mg)   │
│                      │
│ ⚠️ 높은 당류 섭취     │
│    일일 260g         │
│    (기준: 50g)       │
│                      │
│ ✅ 정상 칼로리 섭취   │
│                      │
└──────────────────────┘

┌─ AI 추천사항 ────────┐
│                      │
│ 1. 나트륨 섭취 줄이기 │
│    → 라면, 김치 회수 줄임 │
│                      │
│ 2. 음료 무가당 선택   │
│    → 콜라 → 제로 음료 │
│                      │
│ 3. 정기적 운동       │
│    → 주 3회 30분      │
│                      │
└──────────────────────┘

[통계 보기] [식습관 개선]
```

---

## 🔐 5. 보안 & 개인정보 보호

- ✅ 모든 데이터 로컬 저장 (서버 전송 없음)
- ✅ 건강정보 SQLite 암호화 (sqflite 옵션)
- ✅ 사진 파일은 앱 전용 캐시 폴더에만 저장
- ✅ 앱 삭제시 모든 데이터 자동 삭제
- ⚠️ **의료 고지**: 앱 시작시 필수 고지
  ```
  "⚠️ 주의: 이 앱은 의료 진단 도구가 아닙니다. 
  예측 결과는 참고용이며, 실제 진단은 의료 전문가 상담이 필수입니다."
  ```

---

## 📱 6. 사용자 흐름 (User Journey)

```
[1] 앱 설치 & 실행
    ↓
[2] 스플래시 화면 (1초)
    ↓
[3] 온보딩 확인 → 미완료시 프로필 입력
    ↓
[4] 홈화면
    ├─ 📷 영수증 촬영
    │  ├─ 카메라 열기
    │  ├─ OCR 처리
    │  ├─ 식료품 파싱
    │  ├─ 수동 검증
    │  └─ DB 저장
    ├─ 📋 최근 영수증 보기
    │  ├─ 영수증 리스트
    │  ├─ 항목 선택 → 상세보기
    │  └─ 삭제 옵션
    └─ 📊 대사증후군 예측
       ├─ 현재 위험도 (원형 게이지)
       ├─ 1/3/5년 예측 그래프
       ├─ 위험 요인 분석
       └─ AI 추천사항
```

---

## 🧪 7. 테스트 전략

### 테스트 케이스

| 번호 | 기능 | 예상 결과 |
|------|------|---------|
| T1 | 온보딩 완료 후 프로필 저장 | ✅ UserProfile DB 저장 |
| T2 | 영수증 사진 촬영 | ✅ 이미지 저장 및 OCR 처리 |
| T3 | OCR 텍스트 추출 정확도 | ≥95% 텍스트 인식 |
| T4 | 식료품 자동 파싱 | ≥80% 정확도 |
| T5 | 영양정보 DB 조회 | 정상 조회 및 표시 |
| T6 | 예측 점수 계산 | 0-100 범위, 규칙 정확성 |
| T7 | 여러 영수증 누적 | 월별 데이터 정상 누적 |
| T8 | 오프라인 작동 | 인터넷 없이 기본 기능 정상 작동 |

---

## 📋 8. MVP 개발 단계

### Phase 1: 프로젝트 초기화 (2-3일)
- [ ] Flutter 프로젝트 생성
- [ ] 의존성 추가 및 설정
- [ ] 폴더 구조 생성
- [ ] Material 3 테마 적용
- [ ] README 작성

### Phase 2: 데이터 레이어 (3-4일)
- [ ] Drift 스키마 정의
- [ ] 모든 엔티티 생성
- [ ] Repository 패턴 구현
- [ ] 식료품 JSON 파일 생성 (200개)
- [ ] NutritionDatabase 로더

### Phase 3: 온보딩 & 프로필 (2일)
- [ ] OnboardingScreen UI
- [ ] 사용자 입력 검증
- [ ] BMI 자동 계산
- [ ] 프로필 저장

### Phase 4: 카메라 & OCR (4-5일)
- [ ] CameraScreen UI
- [ ] Google ML Kit 통합
- [ ] image_processor.dart (이미지 전처리)
- [ ] ocr_service.dart (텍스트 추출)
- [ ] 테스트 (5개 영수증 샘플)

### Phase 5: 식료품 파싱 (3일)
- [ ] food_parser.dart (정규표현식 파싱)
- [ ] ReceiptReviewScreen UI
- [ ] 수동 검증 기능
- [ ] 카테고리 자동 분류

### Phase 6: 예측 엔진 (2일)
- [ ] prediction_engine.dart (규칙 기반 계산)
- [ ] 점수 계산 로직 테스트
- [ ] 위험도 분류

### Phase 7: UI 화면 (4-5일)
- [ ] HomeScreen
- [ ] ReceiptListScreen
- [ ] PredictionScreen
- [ ] 차트 & 게이지 위젯
- [ ] 네비게이션

### Phase 8: 통합 & 테스트 (3-4일)
- [ ] 전체 플로우 테스트
- [ ] 성능 최적화
- [ ] 버그 수정
- [ ] APK 빌드

**예상 소요 시간: 3-4주**

---

## 📝 9. 주의사항

1. **의료 책임 고지**
   - 앱 실행시 필수 고지: "이 앱은 의료 진단이 아닙니다"
   - 결과 화면에 "의료 전문가 상담 권장" 배너 표시

2. **식료품 DB 정확성**
   - 초기 200개 식료품만 포함
   - 사용자가 찾지 못한 상품: "미등록" 처리 + 수동 입력
   - 향후 확장: 더 많은 식료품 추가 필요

3. **OCR 한계**
   - 기울어진 영수증, 저품질 사진: 인식 실패 가능
   - 수동 검증 필수
   - 정규표현식 기반이라 100% 완벽하지 않음

4. **데이터 백업**
   - 로컬 저장만 가능
   - Phase 2에서 클라우드 동기화 추가 검토

---

## ✅ 10. 완성 체크리스트

### 기능 완성도
- [ ] 온보딩 화면 UI 완성
- [ ] 프로필 저장/로드
- [ ] 카메라 & 갤러리 연동
- [ ] OCR 텍스트 추출
- [ ] 이미지 전처리
- [ ] 식료품 자동 파싱
- [ ] 수동 검증 UI
- [ ] 영양정보 DB 조회
- [ ] 예측 점수 계산
- [ ] 예측 결과 UI
- [ ] 통계 화면
- [ ] 데이터 누적 및 저장

### 품질 기준
- [ ] 코드 린트 통과 (flutter analyze)
- [ ] UI 테스트 완료
- [ ] 성능 최적화 완료
- [ ] 오프라인 작동 확인
- [ ] APK 빌드 성공

---

## 📚 11. 참고 자료

- [Flutter Documentation](https://flutter.dev/docs)
- [Google ML Kit for Flutter](https://firebase.google.com/docs/ml-kit)
- [Drift ORM](https://drift.simonbinder.eu/)
- [Riverpod State Management](https://riverpod.dev/)
- [한국 대사증후군 진단 기준](https://www.kslis.or.kr/)

---

**프로젝트 시작 준비 완료! 🚀**

이 명세서를 Claude Code에 전달하여 프로젝트를 시작할 수 있습니다.
