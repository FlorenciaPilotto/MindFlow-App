import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mind_flow/screens/home_screen.dart';
import 'package:mind_flow/screens/auth_screen.dart';
import 'package:mind_flow/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MindFlowApp());
}

class MindFlowApp extends StatelessWidget {
  const MindFlowApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindFlow',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const AuthScreen(),
    );
  }
}