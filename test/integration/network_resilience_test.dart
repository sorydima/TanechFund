import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';
import 'package:rechain_vc_lab/core/storage/cache_manager.dart';

/// Интеграционные тесты для проверки offline-first и network resilience.
void main() {
  group('Network Resilience Integration', () {
    late CacheManager cacheManager;

    setUp(() async {
      cacheManager = CacheManager();
      await cacheManager.initialize();
      await cacheManager.clear();
    });

    tearDown(() async {
      await cacheManager.dispose();
    });

    group('Cache Manager', () {
      test('stores and retrieves data', () async {
        const testData = {'key': 'value', 'number': 42};

        final putResult = await cacheManager.put('test_key', testData);
        expect(putResult.isSuccess, true);

        final getResult = cacheManager.get<Map<String, dynamic>>('test_key');
        expect(getResult.isSuccess, true);
        expect(getResult.value, equals(testData));
      });

      test('respects TTL', () async {
        await cacheManager.put('ttl_key', 'data', ttl: const Duration(milliseconds: 100));

        // Сразу после записи — данные доступны
        final immediate = cacheManager.get<String>('ttl_key');
        expect(immediate.value, 'data');

        // Ждём истечения TTL
        await Future.delayed(const Duration(milliseconds: 150));

        final expired = cacheManager.get<String>('ttl_key');
        expect(expired.value, isNull);
      });

      test('getOrFetch uses cache on second call', () async {
        var fetchCount = 0;
        Future<String> fetch() async {
          fetchCount++;
          return 'fetched_data';
        }

        // Первый вызов — fetch
        final result1 = await cacheManager.getOrFetch('cached_fetch', fetch);
        expect(result1.value, 'fetched_data');
        expect(fetchCount, 1);

        // Второй вызов — cache hit
        final result2 = await cacheManager.getOrFetch('cached_fetch', fetch);
        expect(result2.value, 'fetched_data');
        expect(fetchCount, 1); // fetch не вызван повторно
      });

      test('delete removes data', () async {
        await cacheManager.put('delete_key', 'value');
        expect(cacheManager.hasValid('delete_key'), true);

        await cacheManager.delete('delete_key');
        expect(cacheManager.hasValid('delete_key'), false);
      });
    });

    group('Network Manager', () {
      test('detects connectivity', () async {
        final networkManager = NetworkManager();
        await networkManager.initialize();

        // Проверяем что состояние определено
        expect(
          networkManager.currentState,
          anyOf(
            NetworkState.online,
            NetworkState.offline,
          ),
        );

        networkManager.dispose();
      });

      test('internet access check', () async {
        final networkManager = NetworkManager();
        await networkManager.initialize();

        final hasInternet = await networkManager.hasInternetAccess();
        // В тестовой среде результат может быть любым
        expect(hasInternet, isA<bool>());

        networkManager.dispose();
      });
    });
  });
}
