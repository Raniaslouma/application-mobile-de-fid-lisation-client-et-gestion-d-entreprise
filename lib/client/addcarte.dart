import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapplication/helepers/cachehelpers.dart';

import 'indexclient.dart';
import 'infocard.dart';

class Ajoutcarte extends StatefulWidget {
  const Ajoutcarte({Key? key}) : super(key: key);

  @override
  _AjoutcarteState createState() => _AjoutcarteState();
}

class _AjoutcarteState extends State<Ajoutcarte> {
  bool isFormulaireVisible = true;

  final _formKey = GlobalKey<FormState>();
  String? _code;
  Map<String, dynamic> carteInformations = {};
  Map<String, dynamic> historiqueClient = {};
  @override
void initState() {
  CacheHelper.init();
  super.initState();
}


  getData() async {
    await FirebaseFirestore.instance
        .collection('cartes_fidelite')
        .where('code', isEqualTo: CacheHelper.getInfoExist())
        .get()
        .then((QuerySnapshot querySnapshot) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      carteInformations = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {});
    });
    await FirebaseFirestore.instance
        .collection('Historique')
        .where('carteId', isEqualTo: CacheHelper.getInfoExist())
        .get()
        .then((QuerySnapshot historiqueSnapshot) {
      if (historiqueSnapshot.size > 0) {
        // L'historique existe pour ce client
        historiqueClient =
            historiqueSnapshot.docs[0].data() as Map<String, dynamic>;
        log(historiqueClient.toString());
      }
    });
  }

  void verifierCodeCarte() {
    if (_formKey.currentState!.validate()) {
      String codeCarteSaisi = _code ?? '';
      FirebaseFirestore.instance
          .collection('cartes_fidelite')
          .where('code', isEqualTo: codeCarteSaisi)
          .get()
          .then((QuerySnapshot querySnapshot) {
        log(querySnapshot.docs.toString());
        if (querySnapshot.size > 0) {
          // Le code de carte existe dans la base de données
          // Stockage des informations de la carte
          DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
          carteInformations = documentSnapshot.data() as Map<String, dynamic>;

          String marqueAttendue =
              'carrefour'; // Marque attendue pour la vérification
          String marqueCarte = carteInformations['nom entreprise'];

          if (marqueCarte.trim().toLowerCase() ==
              marqueAttendue.trim().toLowerCase()) {
            // La marque de la carte correspond à la marque attendue
            // Récupération de l'historique spécifique à ce client
            FirebaseFirestore.instance
                .collection('Historique')
                .where('carteId', isEqualTo: codeCarteSaisi)
                .get()
                .then((QuerySnapshot historiqueSnapshot) {
              if (historiqueSnapshot.size > 0) {
                // L'historique existe pour ce client
                historiqueClient =
                    historiqueSnapshot.docs[0].data() as Map<String, dynamic>;
              }
            });
            CacheHelper.setInfoExist(codeCarteSaisi);
            setState(() {});
          } else {
            // La marque de la carte ne correspond pas à la marque attendue
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Code incorrect'),
                  content: const Text(
                    'Le code ne correspond pas à la marque attendue.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Le code de carte n'a pas été trouvé dans la base de données
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Code non trouvé'),
                content: const Text(
                  'Ce code n\'a pas été trouvé dans la base de données.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }).catchError((error) {
        print("Erreur lors de la récupération des informations : $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Homeclient();
            }));
          },
          icon: CircleAvatar(
            backgroundColor: Colors.blue[700],
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ),
      body: CacheHelper.getInfoExist() != null
          ? carteInformations.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Info(
                  carteInformations: carteInformations,
                  historiqueClient: historiqueClient,
                  codeCarteSaisi: _code ?? CacheHelper.getInfoExist()!,
                  masquerFormulaire: () {},
                  supprimerInfoCarte: () {},
                )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Entrez le code de votre carte',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Image.asset('images/carte-geant.png',
                        width: 250, height: 250),
                    const SizedBox(height: 20),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _code = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Entrez votre code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(500),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            String scanResult;
                            try {
                              scanResult =
                                  await FlutterBarcodeScanner.scanBarcode(
                                "#ff6666",
                                "Annuler",
                                true,
                                ScanMode.BARCODE,
                              );
                              setState(() {
                                _code = scanResult;
                              });
                            } on PlatformException {
                              scanResult = 'failed!';
                            }
                          },
                          icon: Image.asset(
                            'images/iconscan.png',
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un code valide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Colors.blue[700],
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: verifierCodeCarte,
                      child: const Text('Enregistrer'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
