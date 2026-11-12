import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orbit_workforce/showcase/orbit_app.dart';

void main() {
  testWidgets(
    'mobile navigation reaches attendance and records a demo check-in',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const OrbitApp());
      await tester.pumpAndSettle();
      expect(find.text('Good morning, Sara'), findsOneWidget);
      await tester.tap(find.text('Attendance').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Check in to demo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check in to demo'));
      await tester.pumpAndSettle();
      expect(find.text('You’re checked in'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Arabic preview uses RTL and request navigation works', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const OrbitApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية'));
    await tester.pumpAndSettle();
    expect(find.text('صباح الخير، سارة'), findsOneWidget);
    final context = tester.element(find.text('صباح الخير، سارة'));
    expect(Directionality.of(context), TextDirection.rtl);
    await tester.tap(find.text('الطلبات').last);
    await tester.pumpAndSettle();
    expect(find.text('سجل الطلبات'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
