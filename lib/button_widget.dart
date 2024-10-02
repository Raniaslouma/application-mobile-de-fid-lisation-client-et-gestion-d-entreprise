import 'package:flutter/material.dart';


class ButtonWidget extends StatelessWidget {
  final IconData icon ;
  final String text ;
  final VoidCallback onClicked ;
  
  const ButtonWidget({
    super.key, 
    Key? Key,
    required this.icon,
    required this.text,
    required this.onClicked,
  });
  
@override
  Widget build  (BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
                       // fixedSize: const Size(240,150),
                        backgroundColor:Colors.grey),
        onPressed: onClicked,
        child: buildContent(),
        );

  Widget buildContent() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon, size: 28),
      const SizedBox(width: 16),
      Text(
        text,
        style: const TextStyle(fontSize: 22, color: Colors.white),
      )
    ],
  );
} 