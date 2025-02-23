// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import 'langues.dart';

class CookingStylesScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const CookingStylesScreen({super.key, required this.changeLanguage});

  @override
  _CookingStylesScreenState createState() => _CookingStylesScreenState();
}

class _CookingStylesScreenState extends State<CookingStylesScreen> {
  final PageController _pageController = PageController();
  Locale _locale = const Locale('fr');

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    setState(() {
      _locale = langCode != null ? Locale(langCode) : const Locale('fr');
    });
  }

  final List<Map<String, dynamic>> eggStyles = [
    {
      'name': 'boiled_eggs',
      'duration': 3,
      'result': 'boiled_eggs_result',
      'imagePath': 'assets/images/cuisson-oeuf-coque.jpg'
    },
    {
      'name': 'soft_boiled_eggs',
      'duration': 6,
      'result': 'soft_boiled_eggs_result',
      'imagePath': 'assets/images/cuisson-oeuf-mollet.jpg'
    },
    {
      'name': 'hard_boiled_eggs',
      'duration': 10,
      'result': 'hard_boiled_eggs_result',
      'imagePath': 'assets/images/cuisson-oeuf-dur.jpg'
    },
    {
      'name': 'poached_eggs',
      'duration': 4,
      'result': 'poached_eggs_result',
      'imagePath': 'assets/images/cuisson-oeuf-poche.jpg'
    },
    {
      'name': 'fried_eggs',
      'duration': 4,
      'result': 'fried_eggs_result',
      'imagePath': 'assets/images/cuisson-oeuf-au-plat.jpg'
    },
    {
      'name': 'baked_eggs',
      'duration': 7,
      'result': 'baked_eggs_result',
      'imagePath': 'assets/images/cuisson-oeuf-cocotte.jpg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('app_title'),
            style: TextStyle(
                color: Colors.black,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: Icon(Icons.settings, color: Colors.black, size: 30.0),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LanguageSelectionPage(
                        changeLanguage: widget.changeLanguage,
                      )),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: eggStyles.length,
              itemBuilder: (context, index) {
                return CookingCard(eggStyle: eggStyles[index]);
              },
            ),
          ),
          SizedBox(height: 10.h),
          SmoothPageIndicator(
            controller: _pageController,
            count: eggStyles.length,
            effect: const WormEffect(
                dotColor: Colors.grey, activeDotColor: Colors.yellow),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class CookingCard extends StatefulWidget {
  final Map<String, dynamic> eggStyle;
  const CookingCard({super.key, required this.eggStyle});

  @override
  _CookingCardState createState() => _CookingCardState();
}

class _CookingCardState extends State<CookingCard> {
  int? _remainingTime;
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _startPauseTimer() {
    setState(() {
      if (_isRunning && !_isPaused) {
        _isPaused = true;
        _timer?.cancel();
      } else if (_isRunning && _isPaused) {
        _isPaused = false;
        _startTimer();
      } else {
        _remainingTime = widget.eggStyle['duration'] * 60;
        _isRunning = true;
        _isPaused = false;
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime! > 0 && !_isPaused) {
        setState(() {
          _remainingTime = _remainingTime! - 1;
        });
      } else if (_remainingTime! <= 0) {
        timer.cancel();
        _playAlarmSound();
        _showTimeUpDialog();
        setState(() {
          _isRunning = false;
          _isPaused = false;
        });
      }
    });
  }

  void _playAlarmSound() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("time_up")),
          content: Text(
              AppLocalizations.of(context)!.translate("your_egg_is_ready")),
          actions: [
            TextButton(
              onPressed: () {
                _audioPlayer.stop();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.translate("close"),
                  style: const TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int? seconds) {
    if (seconds == null) return "";
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return "$minutes:${sec.toString().padLeft(2, '0')}";
  }

  void _showTipsDialog(BuildContext context) {
    String tips;
    switch (widget.eggStyle['name']) {
      case 'boiled_eggs':
        tips = AppLocalizations.of(context)!.translate('boiled_eggs_tips');
        break;
      case 'soft_boiled_eggs':
        tips = AppLocalizations.of(context)!.translate('soft_boiled_eggs_tips');
        break;
      case 'hard_boiled_eggs':
        tips = AppLocalizations.of(context)!.translate('hard_boiled_eggs_tips');
        break;
      case 'poached_eggs':
        tips = AppLocalizations.of(context)!.translate('poached_eggs_tips');
        break;
      case 'fried_eggs':
        tips = AppLocalizations.of(context)!.translate('fried_eggs_tips');
        break;
      case 'baked_eggs':
        tips = AppLocalizations.of(context)!.translate('baked_eggs_tips');
        break;
      default:
        tips = AppLocalizations.of(context)!.translate('no_tips_available');
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("chef_tips")),
          content: Text(tips),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate("close"),
                  style: const TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startPauseTimer,
      child: Card(
        margin: EdgeInsets.all(20.w),
        elevation: 7,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              child: Image.asset(
                widget.eggStyle['imagePath'],
                width: double.infinity,
                height: 250.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 50);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!
                          .translate(widget.eggStyle['name']),
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Text(
                      '${AppLocalizations.of(context)!.translate('duration')}: ${widget.eggStyle['duration']} ${AppLocalizations.of(context)!.translate('minutes')}',
                      style: TextStyle(fontSize: 18.sp)),
                  SizedBox(height: 10.h),
                  Text(
                      '${AppLocalizations.of(context)!.translate('result')}: ${AppLocalizations.of(context)!.translate(widget.eggStyle['result'])}',
                      style: TextStyle(fontSize: 18.sp)),
                  SizedBox(height: 20.h),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100.w,
                          height: 100.w,
                          child: CircularProgressIndicator(
                            value: _isRunning
                                ? _remainingTime! /
                                    (widget.eggStyle['duration'] * 60)
                                : 1,
                            strokeWidth: 8,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.yellow),
                          ),
                        ),
                        Text(
                            !_isRunning
                                ? AppLocalizations.of(context)!
                                    .translate("start")
                                : _formatTime(_remainingTime),
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Center(
                    child: InkWell(
                      onTap: () => _showTipsDialog(context),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("discover_chef_tips"),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
