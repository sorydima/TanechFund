import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/screens/blockchain_defi_screen.dart';

void main() {
  group('BlockchainDeFiScreen Widget Tests', () {
    testWidgets('Displays DeFi protocols list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Verify screen title
      expect(find.text('DeFi Протоколы'), findsOneWidget);
      
      // Verify TVL overview section
      expect(find.text('DeFi Обзор'), findsOneWidget);
      expect(find.text('Общая статистика'), findsOneWidget);
      
      // Verify protocol cards are displayed
      expect(find.text('Uniswap V3'), findsOneWidget);
      expect(find.text('Aave V3'), findsOneWidget);
      expect(find.text('Lido'), findsOneWidget);
    });

    testWidgets('Displays category filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Verify category filter chips
      expect(find.text('Все'), findsOneWidget);
      expect(find.text('DEX'), findsOneWidget);
      expect(find.text('Кредитование'), findsOneWidget);
      expect(find.text('Стейкинг'), findsOneWidget);
      expect(find.text('Фарминг'), findsOneWidget);
      expect(find.text('Деривативы'), findsOneWidget);
    });

    testWidgets('Displays protocol details', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Verify APY badges
      expect(find.text('APY'), findsWidgets);
      
      // Verify TVL info
      expect(find.text('TVL'), findsWidgets);
      
      // Verify risk badges
      expect(find.text('Низкий'), findsWidgets);
      expect(find.text('Средний'), findsWidgets);
    });

    testWidgets('Has refresh functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Verify refresh button exists
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      
      // Tap refresh button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();
      
      // Screen should still be displayed
      expect(find.text('DeFi Протоколы'), findsOneWidget);
    });

    testWidgets('Has add protocol FAB', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Verify FAB exists
      expect(find.text('Добавить'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Displays protocol information', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Verify protocol info exists
      expect(find.text('Uniswap V3'), findsOneWidget);
      expect(find.text('Aave V3'), findsOneWidget);
      expect(find.text('Lido'), findsOneWidget);
      expect(find.text('UNI'), findsOneWidget);
      expect(find.text('AAVE'), findsOneWidget);
    });

    testWidgets('Filter chip selection works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BlockchainDeFiScreen(),
        ),
      );

      // Find and tap DEX filter
      final dexChip = find.text('DEX');
      expect(dexChip, findsOneWidget);
      
      await tester.tap(dexChip);
      await tester.pumpAndSettle();
      
      // Screen should still be displayed
      expect(find.text('DeFi Протоколы'), findsOneWidget);
    });
  });
}
