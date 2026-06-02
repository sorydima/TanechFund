import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/core/stability/circuit_breaker.dart';

void main() {
  group('CircuitBreaker Tests', () {
    late CircuitBreaker circuitBreaker;

    setUp(() {
      circuitBreaker = CircuitBreaker(
        maxFailures: 3,
        resetTimeout: const Duration(milliseconds: 500),
      );
    });

    tearDown(() {
      circuitBreaker.dispose();
    });

    group('Initial State', () {
      test('should start in closed state', () {
        expect(circuitBreaker.state, CircuitState.closed);
        expect(circuitBreaker.isOpen, false);
        expect(circuitBreaker.isClosed, true);
        expect(circuitBreaker.isHalfOpen, false);
      });
    });

    group('Closed State', () {
      test('should allow execution in closed state', () async {
        final result = await circuitBreaker.execute(() async => 'success');
        expect(result, 'success');
        expect(circuitBreaker.state, CircuitState.closed);
      });

      test('should track failures', () async {
        for (int i = 0; i < 2; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }
        expect(circuitBreaker.failureCount, 2);
        expect(circuitBreaker.state, CircuitState.closed);
      });

      test('should open after threshold failures', () async {
        for (int i = 0; i < 3; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }
        expect(circuitBreaker.state, CircuitState.open);
        expect(circuitBreaker.isOpen, true);
      });

      test('should reset failure count on success', () async {
        await circuitBreaker.execute(() async => 'success');
        expect(circuitBreaker.failureCount, 0);
        
        try {
          await circuitBreaker.execute(() async => throw Exception('Error'));
        } catch (_) {}
        
        expect(circuitBreaker.failureCount, 1);
        
        await circuitBreaker.execute(() async => 'success');
        expect(circuitBreaker.failureCount, 0);
      });
    });

    group('Open State', () {
      test('should reject execution when open', () async {
        // Open the circuit
        for (int i = 0; i < 3; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }

        expect(circuitBreaker.state, CircuitState.open);

        // Should throw CircuitBreakerOpenException
        expect(
          () => circuitBreaker.execute(() async => 'test'),
          throwsA(isA<CircuitBreakerOpenException>()),
        );
      });

      test('should transition to half-open after timeout', () async {
        // Open the circuit
        for (int i = 0; i < 3; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }

        expect(circuitBreaker.state, CircuitState.open);

        // Wait for timeout
        await Future.delayed(const Duration(milliseconds: 600));

        // Next execution attempt should transition to half-open and allow execution
        bool executed = false;
        await circuitBreaker.execute(() {
          executed = true;
          return Future.value('test');
        });

        expect(executed, true);
        // After success in half-open, circuit closes
        expect(circuitBreaker.state, CircuitState.closed);
      });
    });

    group('Half-Open State', () {
      test('should close on success', () async {
        // Open the circuit
        for (int i = 0; i < 3; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }

        // Wait for timeout
        await Future.delayed(const Duration(milliseconds: 600));

        // Execute successful operation
        await circuitBreaker.execute(() async => 'success');

        expect(circuitBreaker.state, CircuitState.closed);
      });

      test('should reopen on failure', () async {
        // Open the circuit
        for (int i = 0; i < 3; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }

        // Wait for timeout
        await Future.delayed(const Duration(milliseconds: 600));

        // One failure should reopen
        try {
          await circuitBreaker.execute(() async => throw Exception('Error'));
        } catch (_) {}

        expect(circuitBreaker.state, CircuitState.open);
      });
    });

    group('Reset', () {
      test('should reset to closed state', () async {
        // Open the circuit
        for (int i = 0; i < 3; i++) {
          try {
            await circuitBreaker.execute(() async => throw Exception('Error'));
          } catch (_) {}
        }

        expect(circuitBreaker.state, CircuitState.open);

        // Reset
        circuitBreaker.reset();

        expect(circuitBreaker.state, CircuitState.closed);
        expect(circuitBreaker.failureCount, 0);
      });
    });

    group('Concurrent Execution', () {
      test('should handle concurrent executions safely', () async {
        final futures = List.generate(
          10,
          (i) => circuitBreaker.execute(() async => 'success'),
        );

        final results = await Future.wait(futures);
        expect(results.length, 10);
        expect(circuitBreaker.state, CircuitState.closed);
      });
    });
  });
}
