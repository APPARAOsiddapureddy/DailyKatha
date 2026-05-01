import 'package:daily_katha/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DailyKathaApp builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DailyKathaApp()));
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
