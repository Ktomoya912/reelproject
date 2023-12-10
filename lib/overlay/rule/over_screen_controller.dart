import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function();

@immutable
class OverScreenControl {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const OverScreenControl({
    required this.close,
    required this.update,
  });
}
