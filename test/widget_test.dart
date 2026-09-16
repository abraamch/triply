import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triply/app/app.dart';

void main() {
  testWidgets('Renderiza landing de Triply con headline y botones CTA', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TriplyApp(),
      ),
    );

    // Permitir resolución de frames y animaciones
    await tester.pumpAndSettle();

    // Validar título y botones
    expect(find.text('Triply'), findsWidgets);
    expect(find.text('Crear mi viaje'), findsOneWidget);
    expect(find.text('Explorar demo'), findsOneWidget);
  });
}
