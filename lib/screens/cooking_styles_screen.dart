import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:audioplayers/audioplayers.dart';

class CookingStylesScreen extends StatefulWidget {
  const CookingStylesScreen({super.key});

  @override
  _CookingStylesScreenState createState() => _CookingStylesScreenState();
}

class _CookingStylesScreenState extends State<CookingStylesScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> eggStyles = [
    {
      'name': 'Œufs à la coque',
      'duration': 3,
      'result': 'Blanc à peine pris, jaune bien coulant',
      'imagePath': 'assets/images/cuisson-oeuf-coque.jpg'
    },
    {
      'name': 'Œufs mollets',
      'duration': 6,
      'result': 'Blanc bien pris, jaune crémeux',
      'imagePath': 'assets/images/cuisson-oeuf-mollet.jpg'
    },
    {
      'name': 'Œufs durs',
      'duration': 10,
      'result': 'Blanc et jaune complètement cuits',
      'imagePath': 'assets/images/cuisson-oeuf-dur.jpg'
    },
    {
      'name': 'Œufs pochés',
      'duration': 4,
      'result': 'Blanc pris, jaune coulant',
      'imagePath': 'assets/images/cuisson-oeuf-poche.jpg'
    },
    {
      'name': 'Œufs au plat',
      'duration': 4,
      'result': 'Blanc pris, jaune coulant',
      'imagePath': 'assets/images/cuisson-oeuf-au-plat.jpg'
    },
    {
      'name': 'Œufs cocotte',
      'duration': 7,
      'result': 'Blanc pris, jaune coulant',
      'imagePath': 'assets/images/cuisson-oeuf-cocotte.jpg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eggcellent Timer',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow,
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
  final AudioPlayer _audioPlayer =
      AudioPlayer(); // Déclaration du lecteur audio

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

  // Fonction pour jouer le son d'alarme
  void _playAlarmSound() async {
    await _audioPlayer
        .setReleaseMode(ReleaseMode.loop); // Activation de la boucle
    await _audioPlayer
        .play(AssetSource('audio/alarm.mp3')); // Chemin du fichier audio
  }

  // Fonction pour afficher l'alerte lorsque le timer atteint 0
  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Temps écoulé !"),
          content: const Text("Votre œuf est prêt !"),
          actions: [
            TextButton(
              onPressed: () {
                _audioPlayer.stop(); // Arrêter le son en fermant le dialogue
                Navigator.of(context).pop();
              },
              child: const Text("OK", style: TextStyle(color: Colors.black)),
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
      case 'Œufs à la coque':
        tips = "1. N'oubliez pas de saler l'eau de cuisson.\n"
            "2. Ajoutez un peu de vinaigre pour des œufs encore plus faciles à écaler.\n"
            "3. Utilisez des œufs à température ambiante pour une cuisson plus homogène.";
        break;
      case 'Œufs mollets':
        tips =
            "1. Veillez à ne pas trop cuire les œufs pour un jaune crémeux.\n"
            "2. N'oubliez pas de plonger vos œufs dans de l'eau froide après cuisson.";
        break;
      case 'Œufs durs':
        tips =
            "1. Faites cuire les œufs pendant 10 minutes pour obtenir des œufs durs parfaits.\n"
            "2. Refroidissez-les dans de l'eau glacée pour arrêter la cuisson.";
        break;
      case 'Œufs pochés':
        tips =
            "1. Ajoutez du vinaigre à l'eau pour que le blanc se tienne mieux.\n"
            "2. Cassez l'œuf dans un ramequin avant de le plonger dans l'eau chaude.";
        break;
      case 'Œufs au plat':
        tips =
            "1. Pour obtenir un jaune intact, faites chauffer doucement la poêle.\n"
            "2. Utilisez une petite quantité d'huile pour un meilleur résultat.";
        break;
      case 'Œufs cocotte':
        tips = "1. Préchauffez le four avant de cuire vos œufs cocotte.\n"
            "2. Vous pouvez ajouter de la crème fraîche pour encore plus de crémeux.";
        break;
      default:
        tips = "Pas de tips disponibles.";
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tips du chef"),
          content: Text(tips),
          actions: <Widget>[
            TextButton(
              child:
                  const Text("Fermer", style: TextStyle(color: Colors.black)),
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
                  Text(widget.eggStyle['name'],
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Text('Durée : ${widget.eggStyle['duration']} minutes',
                      style: TextStyle(fontSize: 18.sp)),
                  SizedBox(height: 10.h),
                  Text('Résultat : ${widget.eggStyle['result']}',
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
                                ? "Démarrer"
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
                        "Découvrez les tips du chef",
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
