import 'dart:async';

import 'package:lazy_cell/lazy_cell.dart';
import 'package:test/test.dart';

void main() {
  group(
    'LazyCell',
    () {
      test('Synchronous initialization', () {
        final cell = LazyCell(() => 42);
        expect(cell.value, equals(42));
      });

      test('Asynchronous initialization', () async {
        final cell = LazyCell(() async => 42);
        expect(await cell.value, equals(42));
      });

      test('Caches synchronous value', () {
        var callCount = 0;
        final cell = LazyCell(() {
          callCount++;
          return 42;
        });

        expect(cell.value, equals(42));
        expect(cell.value, equals(42));
        expect(callCount, equals(1));
      });

      test('Caches asynchronous value', () async {
        var callCount = 0;
        final cell = LazyCell(() async {
          callCount++;
          return 42;
        });

        expect(await cell.value, equals(42));
        expect(await cell.value, equals(42));
        expect(callCount, equals(1));
      });

      test('Handles synchronous errors', () {
        final cell = LazyCell(() => throw Exception('Test error'));
        expect(() => cell.value, throwsException);
      });

      test('Handles asynchronous errors', () {
        final cell = LazyCell(() async => throw Exception('Test error'));
        expect(cell.value, throwsException);
      });

      test('Reset clears cached value', () {
        var callCount = 0;
        final cell = LazyCell(() {
          callCount++;
          return 42;
        });

        expect(cell.value, equals(42));
        cell.reset();
        expect(cell.value, equals(42));
        expect(callCount, equals(2));
      });

      test('Multiple simultaneous asynchronous access', () async {
        final completer = Completer<int>();
        final cell = LazyCell(() => completer.future);

        final future1 = cell.value;
        final future2 = cell.value;

        completer.complete(42);

        expect(await future1, equals(42));
        expect(await future2, equals(42));
      });

      test('FutureOr typing works correctly', () {
        final syncCell = LazyCell<int>(() => 42);
        final asyncCell = LazyCell<int>(() async => 42);

        expect(syncCell.value, isA<int>());
        expect(asyncCell.value, isA<Future<int>>());
      });
    },
  );
}
