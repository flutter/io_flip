import 'package:flutter/material.dart';

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

  /// logo
  static const TextStyle logo = TextStyle(
    fontFamily: 'Roboto Serif',
    fontWeight: FontWeight.bold,
    fontSize: 40,
    height: 1,
    letterSpacing: 0,
  );

  /// headlineH1
  static const TextStyle headlineH1 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 48,
    height: 1.17,
    letterSpacing: -2,
  );

  /// headlineH2
  static const TextStyle headlineH2 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 36,
    height: 1.33,
    letterSpacing: -1,
  );

  /// headlineH3
  static const TextStyle headlineH3 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 32,
    height: 1.25,
    letterSpacing: -0.5,
  );

  /// headlineH4
  static const TextStyle headlineH4 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 1.14,
    letterSpacing: -0.5,
  );

  /// headlineH4Light
  static const TextStyle headlineH4Light = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 28,
    height: 1.29,
    letterSpacing: -0.5,
  );

  /// headlineH5
  static const TextStyle headlineH5 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 1.17,
    letterSpacing: -0.25,
  );

  /// headlineH5Light
  static const TextStyle headlineH5Light = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 24,
    height: 1.17,
    letterSpacing: -0.25,
  );

  /// headlineH6
  static const TextStyle headlineH6 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.4,
    letterSpacing: -0.25,
  );

  /// headlineH6Light
  static const TextStyle headlineH6Light = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 20,
    height: 1.4,
    letterSpacing: -0.25,
  );

  /// headlineMobileH1
  static const TextStyle headlineMobileH1 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 36,
    height: 1.33,
    letterSpacing: -2,
  );

  /// headlineMobileH2
  static const TextStyle headlineMobileH2 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 32,
    height: 1.25,
    letterSpacing: -1,
  );

  /// headlineMobileH3
  static const TextStyle headlineMobileH3 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 1.29,
    letterSpacing: -0.5,
  );

  /// headlineMobileH4
  static const TextStyle headlineMobileH4 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 1.33,
    letterSpacing: -0.5,
  );

  /// headlineMobileH4Light
  static const TextStyle headlineMobileH4Light = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 24,
    height: 1.33,
    letterSpacing: -0.5,
  );

  /// headlineMobileH5
  static const TextStyle headlineMobileH5 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.4,
    letterSpacing: -0.25,
  );

  /// headlineMobileH5Light
  static const TextStyle headlineMobileH5Light = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 20,
    height: 1.4,
    letterSpacing: -0.25,
  );

  /// headlineMobileH6
  static const TextStyle headlineMobileH6 = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.33,
    letterSpacing: -0.25,
  );

  /// headlineMobileH6Light
  static const TextStyle headlineMobileH6Light = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.33,
    letterSpacing: -0.25,
  );

  /// bodyXL
  static const TextStyle bodyXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.56,
    letterSpacing: 0.15,
  );

  /// bodyXLLink
  static const TextStyle bodyXLLink = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.56,
    letterSpacing: 0.15,
    decoration: TextDecoration.underline,
  );

  /// bodyLG
  static const TextStyle bodyLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.15,
  );

  /// bodyLGLink
  static const TextStyle bodyLGLink = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.15,
    decoration: TextDecoration.underline,
  );

  /// bodyMD
  static const TextStyle bodyMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.5,
  );

  /// bodyMDLink
  static const TextStyle bodyMDLink = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.5,
    decoration: TextDecoration.underline,
  );

  /// bodySM
  static const TextStyle bodySM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// bodySMLink
  static const TextStyle bodySMLink = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0.25,
    decoration: TextDecoration.underline,
  );

  /// bodyXS
  static const TextStyle bodyXS = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 0.5,
  );

  /// bodyXSBold
  static const TextStyle bodyXSBold = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 0.5,
  );

  /// bodyXSLink
  static const TextStyle bodyXSLink = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 0.5,
    decoration: TextDecoration.underline,
  );

  /// buttonLG
  static const TextStyle buttonLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// buttonLGCaps
  static const TextStyle buttonLGCaps = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// buttonMD
  static const TextStyle buttonMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.25,
  );

  /// buttonMDCaps
  static const TextStyle buttonMDCaps = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.25,
  );

  /// buttonSM
  static const TextStyle buttonSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// buttonSMCaps
  static const TextStyle buttonSMCaps = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// linkXL
  static const TextStyle linkXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.56,
    letterSpacing: 0.15,
    decoration: TextDecoration.underline,
  );

  /// linkLG
  static const TextStyle linkLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0.15,
    decoration: TextDecoration.underline,
  );

  /// linkMD
  static const TextStyle linkMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.43,
    letterSpacing: 0.5,
    decoration: TextDecoration.underline,
  );

  /// linkSM
  static const TextStyle linkSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.5,
    letterSpacing: 0.25,
    decoration: TextDecoration.underline,
  );

  /// linkXS
  static const TextStyle linkXS = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 10,
    height: 1.6,
    letterSpacing: 0.5,
    decoration: TextDecoration.underline,
  );

  /// cardNumberXXL
  static const TextStyle cardNumberXXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.bold,
    fontSize: 48,
    height: 1.08,
    letterSpacing: -1,
  );

  /// cardNumberXL
  static const TextStyle cardNumberXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.bold,
    fontSize: 44,
    height: 1.09,
    letterSpacing: -1,
  );

  /// cardNumberLG
  static const TextStyle cardNumberLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.bold,
    fontSize: 38,
    height: 1.11,
    letterSpacing: -0.5,
  );

  /// cardNumberMD
  static const TextStyle cardNumberMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.bold,
    fontSize: 32,
    height: 1.13,
    letterSpacing: -0.5,
  );

  /// cardNumberSM
  static const TextStyle cardNumberSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.bold,
    fontSize: 28,
    height: 1.14,
    letterSpacing: -0.25,
  );

  /// cardNumberXS
  static const TextStyle cardNumberXS = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    height: 1.17,
    letterSpacing: -0.25,
  );

  /// cardTitleXXL
  static const TextStyle cardTitleXXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 1.14,
    letterSpacing: -0.5,
  );

  /// cardTitleXL
  static const TextStyle cardTitleXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 1.17,
    letterSpacing: -0.5,
  );

  /// cardTitleLG
  static const TextStyle cardTitleLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// cardTitleMD
  static const TextStyle cardTitleMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.29,
    letterSpacing: -0.25,
  );

  /// cardTitleSM
  static const TextStyle cardTitleSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.17,
    letterSpacing: -0.25,
  );

  /// cardTitleXS
  static const TextStyle cardTitleXS = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.18,
    letterSpacing: -0.25,
  );

  /// cardDescriptionXXL
  static const TextStyle cardDescriptionXXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 12,
    height: 1.33,
    letterSpacing: 0,
  );

  /// cardDescriptionXL
  static const TextStyle cardDescriptionXL = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 10,
    height: 1.4,
    letterSpacing: 0,
  );

  /// cardDescriptionLG
  static const TextStyle cardDescriptionLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.normal,
    fontSize: 8,
    height: 1.5,
    letterSpacing: 0,
  );
}

class _TextStylesDesktop extends TopDashTextStyles {
  const _TextStylesDesktop._() : super._();

  @override
  TextStyle get displayLarge => TopDashTextStyles.headlineH1;

  @override
  TextStyle get displayMedium => TopDashTextStyles.headlineH2;

  @override
  TextStyle get displaySmall => TopDashTextStyles.headlineH3;

  @override
  TextStyle get headlineLarge => TopDashTextStyles.headlineH4;

  @override
  TextStyle get headlineMedium => TopDashTextStyles.headlineH4Light;

  @override
  TextStyle get headlineSmall => TopDashTextStyles.headlineH5;

  @override
  TextStyle get titleLarge => TopDashTextStyles.cardTitleXL;

  @override
  TextStyle get titleMedium => TopDashTextStyles.cardTitleLG;

  @override
  TextStyle get titleSmall => TopDashTextStyles.cardTitleMD;

  @override
  TextStyle get bodyLarge => TopDashTextStyles.bodyLG;

  @override
  TextStyle get bodyMedium => TopDashTextStyles.bodyMD;

  @override
  TextStyle get bodySmall => TopDashTextStyles.bodySM;

  @override
  TextStyle get labelLarge => TopDashTextStyles.bodyLG;

  @override
  TextStyle get labelMedium => TopDashTextStyles.bodySM;

  @override
  TextStyle get labelSmall => TopDashTextStyles.bodyXS;
}

class _TextStylesMobile extends TopDashTextStyles {
  const _TextStylesMobile._() : super._();

  @override
  TextStyle get displayLarge => TopDashTextStyles.headlineMobileH1;

  @override
  TextStyle get displayMedium => TopDashTextStyles.headlineMobileH2;

  @override
  TextStyle get displaySmall => TopDashTextStyles.headlineMobileH3;

  @override
  TextStyle get headlineLarge => TopDashTextStyles.headlineMobileH4;

  @override
  TextStyle get headlineMedium => TopDashTextStyles.headlineMobileH4Light;

  @override
  TextStyle get headlineSmall => TopDashTextStyles.headlineMobileH5;

  @override
  TextStyle get titleLarge => TopDashTextStyles.cardTitleXL;

  @override
  TextStyle get titleMedium => TopDashTextStyles.cardTitleLG;

  @override
  TextStyle get titleSmall => TopDashTextStyles.cardTitleMD;

  @override
  TextStyle get bodyLarge => TopDashTextStyles.bodyLG;

  @override
  TextStyle get bodyMedium => TopDashTextStyles.bodyMD;

  @override
  TextStyle get bodySmall => TopDashTextStyles.bodySM;

  @override
  TextStyle get labelLarge => TopDashTextStyles.bodyLG;

  @override
  TextStyle get labelMedium => TopDashTextStyles.bodySM;

  @override
  TextStyle get labelSmall => TopDashTextStyles.bodyXS;
}
