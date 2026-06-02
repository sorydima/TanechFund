import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/screens/courses_screen.dart';

void main() {
  group('CoursesScreen Widget Tests', () {
    testWidgets('Displays courses screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify screen title
      expect(find.text('Курсы'), findsOneWidget);
      
      // Verify academy stats
      expect(find.text('REChain Academy'), findsOneWidget);
      expect(find.text('Ваш прогресс'), findsOneWidget);
    });

    testWidgets('Displays progress statistics', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify stats
      expect(find.text('Завершено'), findsOneWidget);
      expect(find.text('В процессе'), findsOneWidget);
      expect(find.text('Часов'), findsOneWidget);
    });

    testWidgets('Displays category filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify category filters
      expect(find.text('Все'), findsOneWidget);
      expect(find.text('Основы'), findsOneWidget);
      expect(find.text('DeFi'), findsOneWidget);
      expect(find.text('NFT'), findsOneWidget);
      expect(find.text('Разработка'), findsOneWidget);
      expect(find.text('Безопасность'), findsOneWidget);
      expect(find.text('DAO'), findsOneWidget);
    });

    testWidgets('Displays course cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify course titles
      expect(find.text('Введение в блокчейн'), findsOneWidget);
      expect(find.text('DeFi Протоколы'), findsOneWidget);
      expect(find.text('NFT: Создание и торговля'), findsOneWidget);
      expect(find.text('Смарт-контракты Solidity'), findsOneWidget);
      expect(find.text('Безопасность в Web3'), findsOneWidget);
      expect(find.text('DAO Управление'), findsOneWidget);
    });

    testWidgets('Displays course instructors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify instructors
      expect(find.text('Алексей Петров'), findsOneWidget);
      expect(find.text('Мария Иванова'), findsOneWidget);
      expect(find.text('Дмитрий Сидоров'), findsOneWidget);
    });

    testWidgets('Displays course levels', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify level badges
      expect(find.text('Новичок'), findsWidgets);
      expect(find.text('Средний'), findsWidgets);
      expect(find.text('Продвинутый'), findsWidgets);
    });

    testWidgets('Displays course prices', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify prices
      expect(find.text('Бесплатно'), findsOneWidget);
      expect(find.text('\$49.99'), findsOneWidget);
      expect(find.text('\$29.99'), findsOneWidget);
      expect(find.text('\$99.99'), findsOneWidget);
    });

    testWidgets('Displays course progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify progress percentages
      expect(find.text('100% завершено'), findsWidgets);
      expect(find.text('65% завершено'), findsWidgets);
      expect(find.text('30% завершено'), findsWidgets);
    });

    testWidgets('Displays course ratings', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify ratings
      expect(find.text('4.8'), findsWidgets);
      expect(find.text('4.9'), findsWidgets);
      expect(find.text('4.7'), findsWidgets);
    });

    testWidgets('Displays student counts', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify student counts
      expect(find.textContaining('студентов'), findsWidgets);
    });

    testWidgets('Has search functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify search button
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Has filter functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify filter button
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('Has suggest course FAB', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify FAB
      expect(find.text('Предложить курс'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb), findsOneWidget);
    });

    testWidgets('Course cards have action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CoursesScreen(),
        ),
      );

      // Verify action buttons
      expect(find.text('Начать'), findsWidgets);
      expect(find.text('Продолжить'), findsWidgets);
      expect(find.text('Повторить'), findsWidgets);
    });
  });
}
