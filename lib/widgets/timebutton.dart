import 'package:flutter/material.dart';

class TimerButton extends StatelessWidget {
  final String title;
  final Duration duration;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;


  const TimerButton({
    required this.title,
    required this.duration,
    required this.onTap,
    this.onLongPress,
    super.key,
  });
  String fortmateDuration(Duration duration){
  return '${duration.inHours.toString().padLeft(2, '0')}:'
      '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
      '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12.0),
        child: Ink(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
              fortmateDuration(duration),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
             ],
            ),
          ),
        ),
      ),
    );
  }
}
