import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/screens/nft_marketplace_screen.dart';

void main() {
  group('NFTMarketplaceScreen Widget Tests', () {
    testWidgets('Displays NFT marketplace', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify screen title
      expect(find.text('NFT Маркетплейс'), findsOneWidget);
      
      // Verify market stats
      expect(find.text('NFT Рынок'), findsOneWidget);
      expect(find.text('Статистика рынка'), findsOneWidget);
    });

    testWidgets('Displays market statistics', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify stats
      expect(find.text('Объём 24h'), findsOneWidget);
      expect(find.text('Продажи'), findsOneWidget);
      expect(find.text('Активные'), findsOneWidget);
    });

    testWidgets('Displays category filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify category filters
      expect(find.text('Все'), findsOneWidget);
      expect(find.text('Искусство'), findsOneWidget);
      expect(find.text('Коллекции'), findsOneWidget);
      expect(find.text('Игры'), findsOneWidget);
      expect(find.text('Метавселенная'), findsOneWidget);
      expect(find.text('Музыка'), findsOneWidget);
      expect(find.text('Фото'), findsOneWidget);
    });

    testWidgets('Displays hot auctions section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify auctions section
      expect(find.text('🔥 Горячие аукционы'), findsOneWidget);
      expect(find.text('Все'), findsWidgets); // "Все" button
    });

    testWidgets('Displays featured collections', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify collections section
      expect(find.text('⭐ Топ коллекции'), findsOneWidget);
      
      // Verify collection names
      expect(find.text('Bored Ape Yacht Club'), findsOneWidget);
      expect(find.text('CryptoPunks'), findsOneWidget);
      expect(find.text('Azuki'), findsOneWidget);
      expect(find.text('Doodles'), findsOneWidget);
    });

    testWidgets('Displays recent sales', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify recent sales section
      expect(find.text('📈 Последние продажи'), findsOneWidget);
    });

    testWidgets('Displays auction cards with timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify auction details
      expect(find.text('Текущая'), findsWidgets);
      expect(find.text('Купить'), findsWidgets);
      expect(find.byIcon(Icons.timer), findsWidgets);
    });

    testWidgets('Has search functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify search button
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('Has filter functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify filter button
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('Has create and buy FABs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify FABs
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('Displays collection floor prices', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify floor prices
      expect(find.text('Floor'), findsWidgets);
      expect(find.textContaining('ETH'), findsWidgets);
    });

    testWidgets('Displays verified badges', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NFTMarketplaceScreen(),
        ),
      );

      // Verify verified badges
      expect(find.byIcon(Icons.verified), findsWidgets);
    });
  });
}
