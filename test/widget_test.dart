import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skyrush/main.dart';
import 'package:skyrush/services/storage_service.dart';

void main() {
  testWidgets('SkyRush displays its splash screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();

    await tester.pumpWidget(const SkyRushApp());

    expect(find.text('SKYRUSH'), findsOneWidget);
  });
}
