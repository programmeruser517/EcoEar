import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ecoear/main.dart'; // adjust if your entrypoint import path differs

void main() {
  testWidgets('EcoEarApp shows active notification banner on launch', (
    WidgetTester tester,
  ) async {
    // Build our EcoEarApp and trigger a frame.
    await tester.pumpWidget(EcoEarApp());

    // Let animations settle (banner fade-in)
    await tester.pumpAndSettle();

    // Verify we see the "EcoEar is active" banner text.
    expect(find.text('EcoEar is active'), findsOneWidget);

    // Verify the curved logo is present in the banner.
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName.endsWith('logo_curved.png'),
      ),
      findsOneWidget,
    );
  });
}
