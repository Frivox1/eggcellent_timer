import 'package:flutter/material.dart';
import 'package:eggcellent_timer/l10n/app_localizations.dart';

class LanguageSelectionPage extends StatelessWidget {
  final Function(Locale) changeLanguage;

  const LanguageSelectionPage({Key? key, required this.changeLanguage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0, // Suppression de l'ombre de l'AppBar
        title: Text(
          AppLocalizations.of(context)!.translate('choose_language'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              LanguageTile(
                title: 'Français',
                locale: Locale('fr'),
                changeLanguage: changeLanguage,
                context: context,
                flagEmoji: '🇫🇷', // Ajout d'un emoji drapeau
              ),
              SizedBox(height: 30),
              LanguageTile(
                title: 'English',
                locale: Locale('en'),
                changeLanguage: changeLanguage,
                context: context,
                flagEmoji: '🇬🇧', // Ajout d'un emoji drapeau
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageTile extends StatelessWidget {
  final String title;
  final Locale locale;
  final Function(Locale) changeLanguage;
  final BuildContext context;
  final String flagEmoji;

  const LanguageTile({
    required this.title,
    required this.locale,
    required this.changeLanguage,
    required this.context,
    required this.flagEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeLanguage(locale);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              flagEmoji,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.yellow[700],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
