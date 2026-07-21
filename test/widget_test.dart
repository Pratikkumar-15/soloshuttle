import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:soloshuttle/main.dart';
import 'package:soloshuttle/providers/user_provider.dart';
import 'package:soloshuttle/providers/training_provider.dart';
import 'package:soloshuttle/providers/settings_provider.dart';
import 'package:soloshuttle/core/services/storage_service.dart';

void main() {
  testWidgets('SoloShuttle app smoke test', (WidgetTester tester) async {
    final storage = SharedPreferencesStorageService();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider(storage)),
          ChangeNotifierProvider(create: (_) => TrainingProvider(storage)),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const SoloShuttleApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('SoloShuttle'), findsOneWidget);
  });
}
