import 'package:flutter/material.dart';

import 'client/loginc.dart';
import 'loginent.dart';

class Started extends StatefulWidget {
  const Started({super.key});

  @override
  _StartedState createState() => _StartedState();
}

class _StartedState extends State<Started> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Vous êtes :",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const loginent()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('images/viiiis.jpg'),
                              fit: BoxFit.contain,
                            ),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            )),
                        width: 180,
                        height: 180,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Entreprise',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16), // adjust spacing between buttons
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Loginclient()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('images/y.jpg'),
                              fit: BoxFit.contain,
                            ),
                            border: Border.all(
                              color: Colors.grey, // set the color of the border
                              width: 2.0,
                            )),
                        width: 180, // adjust image size to fit your design
                        height: 180,
                      ),
                      const SizedBox(
                          height: 8), // adjust spacing between image and text
                      const Text(
                        'Client', // replace with your button text
                        style: TextStyle(
                          fontSize: 20, // adjust text size to fit your design
                          fontWeight: FontWeight
                              .w400, // adjust text style to fit your design
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
    )));
  }
}
