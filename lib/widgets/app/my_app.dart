import 'package:flutter/material.dart';
import 'package:flutter_themoviedb/Theme/app_colors.dart';
import 'package:flutter_themoviedb/library/widgets/inherited/provider.dart';
import 'package:flutter_themoviedb/navigation/main_navigation.dart';
import 'package:flutter_themoviedb/widgets/app/my_app_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.read<MyAppModel>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: AppColors.mainDarkBlue),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.white,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU'),
      ],
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute(model?.isAuth == true),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
