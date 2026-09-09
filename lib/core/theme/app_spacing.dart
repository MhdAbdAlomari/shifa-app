/// Spacing scale for the Shifa design system, aligned with the
/// `surgical_precision_calm` design tokens.
///
/// A 4/8-point grid. Screens and widgets only reference these constants;
/// hand-tuned pixel values are treated as bugs.
class AppSpacing {
  const AppSpacing._();

  // Base spacing scale (matches DESIGN.md — space-xxs..space-3xl).
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  /// Outer boundary margin for every screen (matches DESIGN.md
  /// `screen-edge-margin: 1rem`).
  static const double screenEdge = 16;

  /// Standard interior padding for cards (matches DESIGN.md
  /// `card-inner-padding: 1.25rem`).
  static const double cardPadding = 20;

  /// Card corner radius — 20px for a softer, more modern feel across
  /// cards and modal headers.
  static const double radiusCard = 20;

  /// Button and input radius (12px per DESIGN.md).
  static const double radiusButton = 12;
  static const double radiusSmall = 8;
  static const double radiusPill = 999;

  /// Standard interactive height — 48px so touch targets remain reliable
  /// for gloved hands (DESIGN.md rule).
  static const double buttonHeight = 48;
  static const double inputHeight = 44;
  static const double filterPillHeight = 36;
}
