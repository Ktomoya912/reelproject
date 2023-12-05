import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class RuleScreenControl {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const RuleScreenControl({
    required this.close,
    required this.update,
  });
}
