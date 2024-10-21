import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
    }) : super(key: key);
    final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
    );
  }
}
