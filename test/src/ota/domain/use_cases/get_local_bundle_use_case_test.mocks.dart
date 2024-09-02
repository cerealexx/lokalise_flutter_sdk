// Mocks generated by Mockito 5.4.4 from annotations
// in lokalise_flutter_sdk/test/src/ota/domain/use_cases/get_local_bundle_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart'
    as _i2;
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart' as _i4;
import 'package:lokalise_flutter_sdk/src/ota/domain/services/logger.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [LocalBundleDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalBundleDataSource extends _i1.Mock
    implements _i2.LocalBundleDataSource {
  MockLocalBundleDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> saveBundle({required _i4.Bundle? bundle}) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveBundle,
          [],
          {#bundle: bundle},
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> removeBundle() => (super.noSuchMethod(
        Invocation.method(
          #removeBundle,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i5.Logger {
  MockLogger() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void exception(Exception? exception) => super.noSuchMethod(
        Invocation.method(
          #exception,
          [exception],
        ),
        returnValueForMissingStub: null,
      );
}
