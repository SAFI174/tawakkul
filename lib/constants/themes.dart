import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = FlexThemeData.light(
  scheme: FlexScheme.sanJuanBlue,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 40,
  appBarElevation: 2,
  appBarStyle: FlexAppBarStyle.primary,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    appBarScrolledUnderElevation: 1,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onPrimaryContainer,
    navigationBarSelectedIconSchemeColor: SchemeColor.primary,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onPrimaryContainer,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
  ),
  visualDensity:
      FlexColorScheme.defaultComfortablePlatformDensity(TargetPlatform.android),
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
);
final darkTheme = FlexThemeData.dark(
  scheme: FlexScheme.sanJuanBlue,
  surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
  blendLevel: 13,
  pageTransitionsTheme: PageTransitionsTheme(
    builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
      TargetPlatform.values,
      value: (dynamic _) =>
          const FadeUpwardsPageTransitionsBuilder(), //applying old animation
    ),
  ),
  darkIsTrueBlack: false,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 18,
    useTextTheme: true,
    adaptiveSplash: FlexAdaptive.all(),
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarUnselectedLabelSchemeColor: SchemeColor.onPrimaryContainer,
    navigationBarSelectedIconSchemeColor: SchemeColor.primary,
    navigationBarUnselectedIconSchemeColor: SchemeColor.onPrimaryContainer,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  fontFamily: GoogleFonts.ibmPlexSansArabic().fontFamily,
);
