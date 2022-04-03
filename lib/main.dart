import 'package:cbnits/generated/l10n.dart';
import 'package:cbnits/presentation/country/country_viewmodel.dart';
import 'package:cbnits/presentation/languages/languages_viewmodel.dart';
import 'package:cbnits/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CBNITSApp());
}

class CBNITSApp extends StatelessWidget {
  const CBNITSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CountryViewModel()),
        ChangeNotifierProvider(create: (context) => LanguagesViewModel()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => S.of(context).app_name,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          supportedLocales: S.delegate.supportedLocales,
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supported) {
            return S.delegate.supportedLocales.first;
          },
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: const SplashPage()),
    );
  }
}
