// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeHash() => r'521008c4d005d35bdee7e9d1cde5b6a11ca90a4e';

/// See also [theme].
@ProviderFor(theme)
final themeProvider = AutoDisposeProvider<ThemeData>.internal(
  theme,
  name: r'themeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$currentThemeHash() => r'9dad578fe179ff7bab43a876c48b98ae2f23ee2a';

/// See also [CurrentTheme].
@ProviderFor(CurrentTheme)
final currentThemeProvider =
    AutoDisposeNotifierProvider<CurrentTheme, ThemeMode>.internal(
  CurrentTheme.new,
  name: r'currentThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentTheme = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
