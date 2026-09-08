import 'package:flutter/material.dart';

/// Elevation tokens — deliberately soft. DESIGN.md calls for
/// "atmospheric depth" rather than dark drop shadows, so we combine a
/// 1px `#E5EBE8` border (applied by AppCard) with an ultra-diffused
/// double-shadow.
class AppShadows {
  const AppShadows._();

  /// Standard operational card resting shadow.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color.fromRGBO(15, 110, 86, 0.04),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color.fromRGBO(23, 35, 31, 0.02),
      blurRadius: 4,
      spreadRadius: -1,
      offset: Offset(0, 1),
    ),
  ];

  /// Elevated / dragged state for cards being reallocated.
  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: Color.fromRGBO(15, 110, 86, 0.08),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color.fromRGBO(23, 35, 31, 0.04),
      blurRadius: 6,
      spreadRadius: -1,
      offset: Offset(0, 2),
    ),
  ];
}
