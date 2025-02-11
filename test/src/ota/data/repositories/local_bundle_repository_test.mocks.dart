// Mocks generated by Mockito 5.4.4 from annotations
// in lokalise_flutter_sdk/test/src/ota/data/repositories/local_bundle_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_persistence.dart'
    as _i2;
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart'
    as _i4;
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

/// A class which mocks [BundlePersistence].
///
/// See the documentation for Mockito's code generation for more information.
class MockBundlePersistence extends _i1.Mock implements _i2.BundlePersistence {
  MockBundlePersistence() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> save({required _i4.BundleEntity? bundleEntity}) =>
      (super.noSuchMethod(
        Invocation.method(
          #save,
          [],
          {#bundleEntity: bundleEntity},
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> remove() => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
