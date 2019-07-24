import 'package:flutter/material.dart';
import 'package:mpesa_ledger_flutter/blocs/theme/theme_bloc.dart';

import 'package:mpesa_ledger_flutter/screens/intro/splash_screen.dart';
import 'package:mpesa_ledger_flutter/theme/custom_theme.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: themeBloc.themeControllerStream,
      builder: (context, snapshot) {
        return MaterialApp(
            title: 'Material App',
            theme: CustomTheme(snapshot.data).getTheme,
            debugShowCheckedModeBanner: false,
            home: SplashScreen());
      }
    );
  }
}
