import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eggcellent_timer/l10n/app_localizations.dart';
import 'package:eggcellent_timer/screens/cooking_styles_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import de ScreenUtil

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale savedLocale = await getSavedLocale();
  runApp(MyApp(savedLocale: savedLocale));
}

Future<Locale> getSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString('language_code');
  return langCode != null ? Locale(langCode) : Locale('fr');
}

class MyApp extends StatefulWidget {
  final Locale savedLocale;

  const MyApp({Key? key, required this.savedLocale}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.savedLocale;
  }

  Future<void> _changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), // Définir la taille de design ici
      minTextAdapt: true, // Activer l'adaptation du texte
      splitScreenMode: true, // Activer le mode écran partagé
      builder: (context, child) {
        // Wrap MaterialApp inside the builder
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eggcellent Timer',
          locale: _locale,
          supportedLocales: const [
            Locale('fr', ''),
            Locale('en', ''),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: CookingStylesScreen(changeLanguage: _changeLanguage),
        );
      },
    );
  }
}
