import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triply/app/config/theme/app_theme.dart';
import 'package:triply/core/widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders label correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: ProviderScope(
            child: AppButton(
              label: 'Crear mi viaje',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Crear mi viaje'), findsOneWidget);
  });

  testWidgets('AppButton secondary variant renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: ProviderScope(
            child: AppButton(
              label: 'Explorar demo',
              isSecondary: true,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Explorar demo'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('AppButton shows loading spinner when isLoading=true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: ProviderScope(
            child: AppButton(
              label: 'Cargando',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
