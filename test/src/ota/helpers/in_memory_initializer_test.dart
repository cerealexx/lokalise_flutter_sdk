import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/in_memory_initializer.dart';

void main() {
  group('InMemoryInitializer', () {
    test('empty translations', () async {
      final initializer = InMemoryInitializer(
        localTranslations: {},
        remoteTranslations: {},
      );
      final instance = initializer.lokalise;
      expect(instance, isNotNull);
    });

    test('local translations', () async {
      final initializer = InMemoryInitializer(
        remoteTranslations: {},
        localTranslations: {
          const Locale('en'): {'hello': 'Hello world'},
          const Locale('es'): {'hello': 'Hola mundo'}
        },
      );
      final instance = initializer.lokalise;
      expect(instance, isNotNull);
    });

    test('remote translations', () async {
      final initializer = InMemoryInitializer(
        localTranslations: {},
        remoteTranslations: {
          const Locale('en'): {'hello': 'Hello world'},
          const Locale('es'): {'hello': 'Hola mundo'}
        },
      );
      final instance = initializer.lokalise;
      expect(instance, isNotNull);
    });

    test('local and remote translations', () async {
      final initializer = InMemoryInitializer(
        localTranslations: {
          const Locale('en'): {'hello': 'Hello world (local)'},
          const Locale('es'): {'hello': 'Hola mundo (local)'}
        },
        remoteTranslations: {
          const Locale('en'): {'hello': 'Hello world (remote)'},
          const Locale('es'): {'hello': 'Hola mundo (remote)'}
        },
      );
      final instance = initializer.lokalise;
      expect(instance, isNotNull);
    });
  });
}
