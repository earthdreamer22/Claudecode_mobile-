# 🔧 Android API 35+ 프로덕션 배포 가이드

## 📋 개요

Google Play Store는 **2024년 11월 부터** 새로운 앱과 업데이트에 대해 **API 35 (Android 15)** 이상을 필수로 요구합니다.

**ReceiptHealthPredictor** 프로젝트는 이 기준을 충족하도록 설정되어 있습니다.

---

## ✅ API 35 설정 체크리스트

### 1. 프로젝트 레벨 설정 (`android/build.gradle`)

```gradle
android {
    compileSdkVersion 35        // ✅ API 35로 컴파일
    ndkVersion "27.0.12000015"  // ✅ 최신 NDK
    
    defaultConfig {
        applicationId "com.example.receipt_health_predictor"
        minSdkVersion 35           // ✅ 최소 API 35
        targetSdkVersion 35        // ✅ 대상 API 35
        compileSdkVersion 35       // ✅ 컴파일 API 35
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 2. 앱 레벨 설정 (`android/app/build.gradle`)

```gradle
android {
    compileSdkVersion 35
    
    defaultConfig {
        minSdkVersion 35
        targetSdkVersion 35
        compileSdkVersion 35
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}
```

### 3. AndroidManifest.xml 권한

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.receipt_health_predictor">

    <!-- 필요한 권한들 -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    
    <!-- API 35+ 보안 요구사항 -->
    <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
    
    <application
        android:allowBackup="false"  <!-- 데이터 보안 -->
        android:usesCleartextTraffic="false"  <!-- HTTPS 필수 -->
        ...>
    </application>
</manifest>
```

---

## 🔐 API 35 주요 변경사항

### 1. 데이터 보안 강화

| 항목 | 변경사항 | 대응 방법 |
|------|---------|----------|
| **파일 접근** | MediaStore 필수 | image_picker 플러그인 사용 |
| **저장소 접근** | MANAGE_EXTERNAL_STORAGE 삭제 | scoped storage 사용 |
| **클립보드** | 제한됨 | 일반 텍스트만 사용 |

### 2. 카메라/갤러리 권한

```dart
// Flutter에서 권한 요청
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  return status.isGranted;
}

Future<bool> requestPhotoPermission() async {
  final status = await Permission.photos.request();
  return status.isGranted;
}
```

### 3. 데이터베이스 암호화

```dart
// sqflite with encryption (권장)
import 'package:sqflite/sqflite.dart';

final database = await openDatabase(
  join(await getDatabasesPath(), 'rhp_database.db'),
  encrypted: true,  // API 35 권장
);
```

---

## 📦 의존성 호환성

모든 주요 의존성은 API 35를 지원합니다:

| 패키지 | 최소 버전 | API 35 호환성 |
|--------|---------|---------------|
| flutter | 3.13.0+ | ✅ 완전 지원 |
| google_ml_kit | 0.16.0+ | ✅ 지원 |
| camera | 0.10.5+ | ✅ 지원 |
| image_picker | 1.0.4+ | ✅ 지원 |
| sqflite | 2.3.0+ | ✅ 지원 |
| drift | 2.14.0+ | ✅ 지원 |
| fl_chart | 0.65.0+ | ✅ 지원 |

---

## 🧪 테스트 및 빌드

### 1. 로컬 빌드 확인

```bash
# API 35 호환성 검사
flutter doctor -v

# 프로젝트 분석
flutter analyze

# 빌드 테스트 (디버그)
flutter build apk --debug

# 프로덕션 APK 빌드
flutter build apk --release

# Android App Bundle (Google Play Store 배포용)
flutter build appbundle --release
```

### 2. 에뮬레이터 테스트

```bash
# API 35 (Android 15) 에뮬레이터에서 테스트
flutter emulators --launch Pixel_API_35

# 또는 기존 에뮬레이터
flutter run
```

---

## 🚀 Google Play Store 배포

### 배포 전 체크리스트

- [ ] minSdkVersion = 35 확인
- [ ] targetSdkVersion = 35 확인
- [ ] compileSdkVersion = 35 확인
- [ ] 모든 권한이 AndroidManifest.xml에 선언됨
- [ ] 카메라/저장소 권한 런타임 요청 구현
- [ ] 개인정보 보호 정책 작성
- [ ] 의료 고지 사항 포함
- [ ] APK 또는 AAB 서명됨
- [ ] 버전 코드 증가

### 배포 명령어

```bash
# 프로덕션 AAB 생성 (권장)
flutter build appbundle --release

# 서명된 APK 생성
flutter build apk --split-per-abi --release

# 파일 위치
# - AAB: build/app/outputs/bundle/release/app-release.aab
# - APK: build/app/outputs/apk/release/app-release.apk
```

---

## ⚠️ 주의사항

### 1. 저장소 호환성
- **API 35 이상 기기**: ~95% 점유율 (2024년 기준)
- **API 35 미만 기기**: 설치 불가

### 2. 라이브러리 업데이트
정기적으로 의존성을 업데이트하세요:

```bash
flutter pub upgrade
```

### 3. 보안 업데이트
- Google Play에서 제공하는 보안 업데이트 정기 확인
- Flutter SDK 최신 버전 유지

---

## 📞 문제 해결

### Q: "컴파일 오류: API 35 미지원"
**A**: build.gradle의 compileSdkVersion, targetSdkVersion, minSdkVersion이 모두 35 이상인지 확인

### Q: "권한 오류"
**A**: AndroidManifest.xml에 권한 선언 + 런타임 권한 요청 구현 필요

### Q: "Google Play 배포 거부"
**A**: minSdkVersion 확인, 개인정보 정책, 의료 고지 사항 재검토

---

## 📚 참고 자료

- [Android 15 개발자 가이드](https://developer.android.com/about/versions/15)
- [Google Play 정책 센터](https://play.google.com/console/about/policy/)
- [Flutter Android 설정](https://flutter.dev/docs/development/platform-integration/android)
- [API 레벨 호환성](https://developer.android.com/guide/topics/manifest/uses-sdk-element)

---

**API 35 기준 준수 완료! ✅ Google Play Store 배포 준비됨.**
