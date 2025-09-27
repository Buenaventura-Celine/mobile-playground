import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_playground/main.dart';

void main() {
  group('MyApp Tests', () {
    testWidgets('should create MyApp widget', (WidgetTester tester) async {
      const app = MyApp();
      expect(app, isA<MyApp>());
    });

    testWidgets('should render MaterialApp with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Flutter Demo');
    });

    testWidgets('should use Material3 design', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
    });

    testWidgets('should have deep purple seed color', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.colorScheme.primary, isNotNull);
    });

    testWidgets('should set MyHomePage as home', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.byType(MyHomePage), findsOneWidget);
    });
  });

  group('MyHomePage Tests', () {
    testWidgets('should create MyHomePage with required title', (WidgetTester tester) async {
      const homePage = MyHomePage(title: 'Test Title');
      expect(homePage.title, 'Test Title');
    });

    testWidgets('should display correct title in AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test App Bar'),
        ),
      );
      
      expect(find.text('Test App Bar'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should have FloatingActionButton with add icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display initial instruction text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      expect(find.text('You have pushed the button this many times:'), findsOneWidget);
    });
  });

  group('Counter Functionality Tests', () {
    testWidgets('should start with counter at 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should increment counter when button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      expect(find.text('0'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      
      expect(find.text('1'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('should increment counter multiple times', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should use headlineMedium text style for counter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      final counterText = tester.widget<Text>(find.text('0'));
      final theme = Theme.of(tester.element(find.text('0')));
      expect(counterText.style, theme.textTheme.headlineMedium);
    });
  });

  group('UI Layout Tests', () {
    testWidgets('should have Scaffold as main structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should center content in body', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should have Column with center alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('should have floating action button with increment tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MyHomePage(title: 'Test'),
        ),
      );
      
      final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
      expect(fab.tooltip, 'Increment');
    });
  });
}