import 'package:visibility_repository/src/visibility_detector.dart';
import 'package:visibility_repository/src/visibility_repository_io.dart'
    if (dart.library.html) 'package:visibility_repository/src/visibility_repository_web.dart';

/// {@template visibility_repository}
/// A repository to detect changes in the visibility of the application
/// {@endtemplate}
class VisibilityRepository {
  /// {@macro visibility_repository}
  VisibilityRepository({
    VisibilityDetector? visibilityDetector,
  }) : _visibilityDetector = visibilityDetector ?? VisibilityDetectorImpl();

  final VisibilityDetector _visibilityDetector;

  Stream<bool> get visibility => _visibilityDetector.visibility;
}
