
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'listentrep.dart';
import 'loginc.dart';

class signupclientPage extends StatefulWidget {
  const signupclientPage({super.key});

  @override
  State<signupclientPage> createState() => _signupclientPageState();
}

class _signupclientPageState extends State<signupclientPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
 // final _auth = FirebaseAuth.instance;
  //final _firestore = FirebaseFirestore.instance;

  final TextEditingController _passwordController = TextEditingController();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cinController = TextEditingController();
  final _ageController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String?
   //_email,
     // _password,
      nom,
      prenom,
      sexe,
      age,
      cin,
      ville,
      telephone,
      email,
      Datedenaissance;
  CollectionReference users =
      FirebaseFirestore.instance.collection('usersClient');
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'sexe': dropdownValue,
          'age': _ageController.text,
          'ville': selectedCity,
          'cin': _cinController.text,
          'telephone': _telephoneController.text,
          'email': _emailController.text,

          // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

// date de naissance
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dateController.text = picked.toString();
  //     });
  //   }
  // }

// sexe
  String dropdownValue = 'Femme';
  List<String> options = ['Femme', 'Homme'];
  String? selectedCity;
  List<String> tunisianCities = [
    'Tunis',
    'Ariana',
    'Ben Arous',
    'Manouba',
    'Nabeul',
    'Zaghouan',
    'Bizerte',
    'Béja',
    'Jendouba',
    'Kef',
    'Siliana',
    'Kairouan',
    'Kasserine',
    'Sidi Bouzid',
    'Sousse',
    'Monastir',
    'Mahdia',
    'Sfax',
    'Gabès',
    'Medenine',
    'Tataouine',
    'Gafsa',
    'Tozeur',
    'Kebili'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                 margin:const EdgeInsets.only(top:40),
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      const Align(
                        alignment: Alignment.center,
                        
                        child: Text("S'inscrire",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 83, 83, 83),
                                fontWeight: FontWeight.w600)),
                      ),
                      Image.asset("images/login.jpg", width: 250, height: 250),
                      TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          hintText: 'nom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir votre nom';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _nomController.text = value!;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _prenomController,
                        decoration: InputDecoration(
                          hintText: 'prénom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre prénom';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _prenomController.text = value!;
                        },
                      ),
                      const SizedBox(height: 15),
                      InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          labelText: 'Sexe',
                        ),
                        child: DropdownButton<String>(
                          //hint: Text('Choisir une option'),
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 10,
                          elevation:
                              5, // change the elevation of the dropdown menu

                          dropdownColor: Colors.grey,
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },

                          items: options
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          hintText: 'Age',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un âge.';
                          }
                          int? age = int.tryParse(value);
                          if (age == null || age < 17 || age > 100) {
                            return 'L\'âge doit être compris entre 17 et 100 ans.';
                          }
                          return null; // Retourne null si la validation est réussie
                        },
                      ),
                      const SizedBox(height: 15),
                      InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          labelText: 'adresse',
                        ),
                        child: DropdownButton<String>(
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 10,
                          elevation: 5,
                          dropdownColor: Colors.grey,
                          value: selectedCity,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCity = newValue!;
                            });
                          },
                          items: tunisianCities
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cinController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          hintText: 'CIN',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre CIN';
                          }

                          if (value.length != 8) {
                            return 'Veuillez entrer un nombre à 8 chiffres';
                          }

                          // Autres conditions de validation si nécessaire

                          return null; // Retourne null si la valeur est valide
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _telephoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Telephone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir votre numéro de téléphone.';
                          }

                          if (value.length != 8 ||
                              int.tryParse(value) == null) {
                            return 'Veuillez entrer un nombre à 8 chiffres.';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _telephoneController.text = value!;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir votre adresse e-mail';
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Veuillez saisir une adresse e-mail valide';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _emailController.text = value!;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          } else if (value.length < 6) {
                            return 'Le mot de passe doit avoir au moins 6 caractères';
                          } else if (!RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).*$')
                              .hasMatch(value)) {
                            return 'Le mot de passe doit contenir à la fois des chiffres et des lettres';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _passwordController.text = value!;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: _obscurePassword,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Confirmez le mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la confirmation du mot de passe';
                          } else if (value != _passwordController.text) {
                            return 'La confirmation du mot de passe ne correspond pas';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _confirmPasswordController.text = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addUser();

                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) {
                              print("created succefuly");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ListEntreprise()),
                              );
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(120, 40),
                            backgroundColor:
                                const Color.fromARGB(255, 26, 64, 233)),
                        child: const Text("s'inscrire"),
                      ),
                      const SizedBox(height: 17),
                      Text.rich(
                        TextSpan(
                          text: "si vous avez déja un compte?",
                          children: [
                            TextSpan(
                                text: "se connecter",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 31, 81, 248),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Loginclient()),
                                    );
                                  }),
                          ],
                        ),
                      )
                    ])))));
  }
}