plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rhp.receipt_health_predictor"
    compileSdk = 36  // Google Play Store 프로덕션 기준
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.rhp.receipt_health_predictor"
        minSdk = 24  // 하위 호환성 유지
        targetSdk = 36  // Google Play Store 프로덕션 기준
        versionCode = 1
        versionName = "1.0.0"

        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            // R8 최적화 완전 비활성화 (메모리 제약)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Korean OCR 지원을 위한 ML Kit Text Recognition Korean 추가
    implementation("com.google.mlkit:text-recognition-korean:16.0.1")
}
