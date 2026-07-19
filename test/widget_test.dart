import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:soloshuttle/main.dart';
import 'package:soloshuttle/providers/user_provider.dart';
import 'package:soloshuttle/providers/training_provider.dart';
import 'package:soloshuttle/providers/settings_provider.dart';

void main() {
  testWidgets('SoloShuttle app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => TrainingProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const SoloShuttleApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('SoloShuttle'), findsOneWidget);
  });
}
