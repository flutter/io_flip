import 'package:flutter/material.dart';

const _base = TextStyle(
  fontFamily: 'Google Sans',
  color: Color(0xFF18191C),
);

/// Text styles used in the Top Dash UI.
abstract class TopDashTextStyles {
  const TopDashTextStyles._();

  /// Text styles for desktop devices.
  static const desktop = _TextStylesDesktop._();

  /// Text styles for mobile devices.
  static const mobile = _TextStylesMobile._();

  /// Creates a [TextTheme] from the text styles.
  TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  /// Display large text style.
  TextStyle get displayLarge;

  /// Display medium text style.
  TextStyle get displayMedium;

  /// Display small text style.
  TextStyle get displaySmall;

  /// Headline large text style.
  TextStyle get headlineLarge;

  /// Headline medium text style.
  TextStyle get headlineMedium;

  /// Headline small text style.
  TextStyle get headlineSmall;

  /// Title large text style.
  TextStyle get titleLarge;

  /// Title medium text style.
  TextStyle get titleMedium;

  /// Title small text style.
  TextStyle get titleSmall;

  /// Body large text style.
  TextStyle get bodyLarge;

  /// Body medium text style.
  TextStyle get bodyMedium;

  /// Body small text style.
  TextStyle get bodySmall;

  /// Label large text style.
  TextStyle get labelLarge;

  /// Label medium text style.
  TextStyle get labelMedium;

  /// Label small text style.
  TextStyle get labelSmall;
}

class _TextStylesDesktop extends TopDashTextStyles {
  const _TextStylesDesktop._() : super._();

  @override
  TextStyle get displayLarge => _base.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w500,
        height: 7 / 6,
      );

  @override
  TextStyle get displayMedium => _base.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        height: 4 / 3,
      );

  @override
  TextStyle get displaySmall => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 5 / 4,
      );

  @override
  TextStyle get headlineLarge => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 8 / 7,
      );

  @override
  TextStyle get headlineMedium => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 36 / 28,
      );

  @override
  TextStyle get headlineSmall => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 28 / 24,
      );

  @override
  TextStyle get titleLarge => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 28 / 24,
      );

  @override
  TextStyle get titleMedium => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 28 / 20,
      );

  @override
  TextStyle get titleSmall => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 28 / 20,
      );

  @override
  TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  @override
  TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );

  @override
  TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 18 / 12,
      );

  @override
  TextStyle get labelLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
      );

  @override
  TextStyle get labelMedium => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  @override
  TextStyle get labelSmall => _base.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );
}

class _TextStylesMobile extends TopDashTextStyles {
  const _TextStylesMobile._() : super._();

  @override
  TextStyle get displayLarge => _base.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        height: 48 / 36,
      );

  @override
  TextStyle get displayMedium => _base.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 40 / 32,
      );

  @override
  TextStyle get displaySmall => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 36 / 28,
      );

  @override
  TextStyle get headlineLarge => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 32 / 24,
      );

  @override
  TextStyle get headlineMedium => _base.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 32 / 24,
      );

  @override
  TextStyle get headlineSmall => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 28 / 20,
      );

  @override
  TextStyle get titleLarge => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 28 / 20,
      );

  @override
  TextStyle get titleMedium => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 24 / 18,
      );

  @override
  TextStyle get titleSmall => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 24 / 24,
      );

  @override
  TextStyle get bodyLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  @override
  TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );

  @override
  TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 18 / 12,
      );

  @override
  TextStyle get labelLarge => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
      );

  @override
  TextStyle get labelMedium => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  @override
  TextStyle get labelSmall => _base.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );
}
