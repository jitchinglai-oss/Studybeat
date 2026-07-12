import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studybeat/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Welcome screen shows Studybeat brand', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StudybeatApp()));
    await tester.pumpAndSettle();

    expect(find.text('Studybeat'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Explore Demo'), findsOneWidget);
  });

  testWidgets('Explore Demo opens dashboard greeting', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StudybeatApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore Demo'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Jonah'), findsWidgets);
    expect(find.text("Today's Sessions"), findsOneWidget);
  });
}
