import 'package:archive/archive.dart';

class BundleResponse {
  final Archive bundle;
  final int version;

  BundleResponse({required this.bundle, required this.version});
}
