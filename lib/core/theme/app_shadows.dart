import 'package:flutter/material.dart';

/// Elevation tokens — deliberately soft. DESIGN.md calls for
/// "atmospheric depth" rather than dark drop shadows, so cards read as
/// floating (large-blur, low-opacity, downward-offset) rather than
/// outlined with a hard border.
class AppShadows {
  const AppShadows._();

  /// Standard operational card resting shadow — diffused and floating.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color.fromRGBO(15, 110, 86, 0.06),
      blurRadius: 20,
      spreadRadius: -6,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color.fromRGBO(23, 35, 31, 0.03),
      blurRadius: 6,
      spreadRadius: -2,
      offset: Offset(0, 2),
    ),
  ];

  /// Elevated / dragged state for cards being reallocated.
  static const List<BoxShadow> cardElevated = [
    BoxShadow(
      color: Color.fromRGBO(15, 110, 86, 0.12),
      blurRadius: 32,
      spreadRadius: -6,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color.fromRGBO(23, 35, 31, 0.05),
      blurRadius: 8,
      spreadRadius: -2,
      offset: Offset(0, 3),
    ),
  ];
}
