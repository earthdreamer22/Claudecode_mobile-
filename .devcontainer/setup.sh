#!/bin/bash
set -e

echo "=== Flutter & Android SDK 자동 설치 스크립트 ==="

# Flutter 설치
if [ ! -d "/home/codespace/flutter" ]; then
  echo "Flutter 설치 중..."
  git clone https://github.com/flutter/flutter.git -b stable /home/codespace/flutter --depth 1
fi

export PATH="$PATH:/home/codespace/flutter/bin"

# Android SDK 설치
if [ ! -d "/home/codespace/android-sdk/cmdline-tools" ]; then
  echo "Android SDK 설치 중..."
  mkdir -p /home/codespace/android-sdk
  cd /home/codespace/android-sdk
  wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" -O cmdline-tools.zip
  unzip -q cmdline-tools.zip
  mkdir -p cmdline-tools/latest
  mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
  rm cmdline-tools.zip
fi

export ANDROID_HOME="/home/codespace/android-sdk"
export ANDROID_SDK_ROOT="/home/codespace/android-sdk"
export PATH="$PATH:/home/codespace/android-sdk/cmdline-tools/latest/bin"

# Android SDK 라이선스 동의 및 필수 패키지 설치
echo "Android SDK 라이선스 동의 및 패키지 설치 중..."
yes | sdkmanager --licenses > /dev/null 2>&1 || true
sdkmanager "platforms;android-36" "platforms;android-35" "build-tools;36.0.0" "platform-tools" > /dev/null 2>&1

# Flutter 설정
flutter config --android-sdk /home/codespace/android-sdk > /dev/null 2>&1

# Flutter 의존성 설치
echo "Flutter 패키지 설치 중..."
cd /workspaces/Claudecode_mobile-
flutter pub get

echo "=== 설치 완료 ==="
echo "flutter doctor 실행:"
flutter doctor

echo ""
echo "APK 빌드 명령어:"
echo "flutter build apk --release --split-per-abi --target-platform android-arm64"
