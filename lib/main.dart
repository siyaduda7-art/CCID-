import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/ccid_theme.dart';

void main() {
  runApp(const CcidConnectApp());
}

class CcidConnectApp extends StatelessWidget {
  const CcidConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CCID Connect',
      debugShowCheckedModeBanner: false,
      theme: CcidTheme.theme(),
      home: const HomeScreen(),
    );
  }
}