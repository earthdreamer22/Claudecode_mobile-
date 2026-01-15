# 📱 ReceiptHealthPredictor (RHP)

> 마트 영수증 기반 만성질환(대사증후군) 위험도 예측 Flutter 앱

## 🎯 프로젝트 개요

영수증을 촬영하면 구매한 식료품을 자동으로 분석하여 대사증후군(당뇨, 고혈압 등) 위험도를 예측하는 모바일 애플리케이션입니다.

### 주요 기능

- 📷 **영수증 OCR**: Google ML Kit을 활용한 텍스트 자동 인식
- 🍎 **식료품 자동 파싱**: 정규표현식 기반 상품명 추출 및 영양정보 매칭
- 📊 **건강 위험도 예측**: BMI, 나트륨, 당류, 지방, 가족력 기반 규칙 엔진
- 📈 **통계 시각화**: 일별/주별/월별 영양소 섭취 분석 및 차트
- 🔒 **로컬 저장**: 모든 데이터는 디바이스 내부에만 저장 (개인정보 보호)

## 🏗️ 기술 스택

- **언어**: Dart 3.10+ / Flutter 3.38+
- **플랫폼**: Android (API 35+, minSdk 24)
- **상태관리**: Riverpod 2.4+
- **로컬 DB**: Drift (SQLite ORM)
- **OCR**: Google ML Kit Text Recognition
- **차트**: fl_chart
- **이미지 처리**: camera, image_picker, image

## 📁 프로젝트 구조

```
lib/
├── config/                  # 테마, 상수 설정
├── data/
│   ├── database/           # Drift 데이터베이스 엔티티
│   ├── models/             # 데이터 모델
│   ├── repositories/       # Repository 패턴
│   └── datasources/        # 데이터 소스 (JSON, API)
├── domain/
│   ├── entities/           # 도메인 엔티티
│   └── usecases/           # 비즈니스 로직
├── presentation/
│   ├── screens/            # UI 화면
│   ├── widgets/            # 재사용 가능한 위젯
│   └── providers/          # Riverpod 프로바이더
└── utils/                  # 유틸리티 (OCR, 파싱, 로깅)
```

## 🚀 시작하기

### 필수 조건

- Flutter SDK 3.13.0 이상
- Dart SDK 3.0.0 이상
- Android Studio / VS Code
- Android SDK (API 35)

### 설치

1. 저장소 클론
```bash
git clone <repository-url>
cd receipt_health_predictor
```

2. 의존성 설치
```bash
flutter pub get
```

3. 빌드 러너 실행 (Drift, json_serializable)
```bash
flutter pub run build_runner build
```

4. 앱 실행
```bash
flutter run
```

## 📦 주요 의존성

```yaml
dependencies:
  # 상태관리
  flutter_riverpod: ^2.4.0

  # 데이터베이스
  drift: ^2.14.0
  sqflite: ^2.3.0

  # 카메라 & OCR
  camera: ^0.10.5
  google_mlkit_text_recognition: ^0.13.0

  # UI
  fl_chart: ^0.65.0
  percent_indicator: ^4.1.0
```

## 🗄️ 데이터베이스 스키마

### 주요 테이블

1. **UserProfile** - 사용자 프로필 (나이, 성별, 키, 몸무게, 가족력)
2. **Receipts** - 영수증 메타데이터
3. **FoodItems** - 식료품 상세 정보 (영양정보 포함)
4. **HealthStats** - 일별 건강 통계

## 🧠 예측 알고리즘

### 대사증후군 위험도 점수 (0-100점)

| 요소 | 가중치 | 기준 |
|------|--------|------|
| BMI | 20% | 25 이상 고위험 |
| 나트륨 | 30% | 일일 2000mg 초과 |
| 당류 | 25% | 일일 50g 초과 |
| 지방 | 15% | 일일 20g 초과 |
| 가족력 | 10% | 당뇨/고혈압/심장병 |

### 위험도 분류

- 🟢 **안전** (0-20점)
- 🟡 **주의** (20-40점)
- 🟠 **경고** (40-60점)
- 🔴 **위험** (60-100점)

## 📱 화면 구성

1. **스플래시** → 온보딩 체크
2. **온보딩** → 사용자 프로필 입력
3. **홈** → 최근 영수증, 주간 영양소, 위험도 요약
4. **카메라** → 영수증 촬영 또는 갤러리 선택
5. **영수증 검증** → 파싱된 항목 수동 검증
6. **예측 결과** → 위험도, 그래프, 권장사항

## ⚠️ 주의사항

**이 앱은 의료 진단 도구가 아닙니다.**

예측 결과는 참고용이며, 실제 건강 진단은 반드시 의료 전문가와 상담하세요.

## 🛠️ 개발 단계

- [x] Phase 1: 프로젝트 초기화 (완료)
- [x] Phase 2: 데이터 레이어 구축 (완료)
- [x] Phase 3: 온보딩 & 프로필 (완료)
- [ ] Phase 4: 카메라 & OCR
- [ ] Phase 5: 식료품 파싱
- [ ] Phase 6: 예측 엔진
- [ ] Phase 7: UI 화면
- [ ] Phase 8: 통합 테스트

**현재 진행률**: 37.5% (3/8 단계 완료)

## 📝 라이선스

이 프로젝트는 학습 및 연구 목적으로 제작되었습니다.

## 🙏 Credits

- Flutter Team
- Google ML Kit
- Drift ORM
- Riverpod Community
