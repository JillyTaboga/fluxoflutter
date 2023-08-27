import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/presentation/panel/panel_screen.dart';
import 'package:fluxoflutter/presentation/theme/theme_controller.dart';
import 'package:intl/intl.dart';

void main() async {
  Intl.defaultLocale = ('pt_BR');
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeProvider),
      themeMode: ref.watch(currentThemeProvider),
      home: const ChartScreen(),
    );
  }
}
