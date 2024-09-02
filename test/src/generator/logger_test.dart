import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/generator/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:logger/logger.dart' as package;
import 'package:mockito/mockito.dart';

import 'logger_test.mocks.dart';

@GenerateMocks([package.Logger])
void main() {
  group('Logger tests', () {
    late Logger logger;
    late MockLogger mockPackageLogger;

    setUp(() {
      mockPackageLogger = MockLogger();
      logger = Logger(logger: mockPackageLogger);
    });

    test('singleton', () {
      expect(Logger.instance, isInstanceOf<Logger>());
      expect(Logger.instance, equals(Logger.instance));
    });

    test('info', () {
      const message = 'This is a message';
      logger.info(message);
      verify(mockPackageLogger.i(message)).called(1);
    });

    test('warning', () {
      const message = 'This is a message';
      logger.warning(message);
      verify(mockPackageLogger.w(message)).called(1);
    });

    test('error', () {
      const message = 'This is a message';
      logger.error(message);
      verify(mockPackageLogger.e(message)).called(1);
    });
  });
}
