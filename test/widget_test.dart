// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';

import 'package:fashion/main.dart'; // CORRECT → ton projet s'appelle "fashion"

void main() {
  testWidgets('StyleCast launches without crashing', (WidgetTester tester) async {
    // On lance ton vrai main.dart (StyleCastApp attend une List<CameraDescription>)
    await tester.pumpWidget(const StyleCastApp(cameras: []));

    // On attend que tout soit bien rendu (Sizer + MaterialApp + tout le reste)
    await tester.pumpAndSettle();

    // Si on arrive ici sans crash → le test passe
    expect(find.byType(StyleCastApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);

    // Vérification légère que la bottom bar est bien là
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}