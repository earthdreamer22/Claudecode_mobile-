// Basic Flutter widget test for RHP app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:receipt_health_predictor/main.dart';
import 'package:receipt_health_predictor/presentation/providers/user_provider.dart';

void main() {
  setUp(() {
    // SharedPreferences 초기화
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // SharedPreferences 모의 객체 생성
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const ReceiptHealthPredictorApp(),
      ),
    );

    // Verify that the app title exists
    expect(find.text('ReceiptHealthPredictor'), findsOneWidget);
    expect(find.text('영수증 기반 건강 예측'), findsOneWidget);

    // Verify that the splash screen loading indicator exists
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
