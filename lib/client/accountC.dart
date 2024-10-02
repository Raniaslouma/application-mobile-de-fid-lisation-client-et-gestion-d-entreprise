import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'indexclient.dart';
import 'parametre.dart';

class ModifierProfile extends StatefulWidget {
  const ModifierProfile({super.key});

  @override
  State<ModifierProfile> createState() => _ModifierProfileState();
}

class _ModifierProfileState extends State<ModifierProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
          
          'telephone': _telephoneController.text,
          'email': _emailController.text,

          // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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
                return Parametre();
              }));
            },
            icon: CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Image.asset(
                        "images/account.png",
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          hintText: 'ranya',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _prenomController,
                        decoration: InputDecoration(
                          hintText: 'slouma',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                      const SizedBox(height: 10),
                      // InputDecorator(
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(7.0),
                      //     ),
                      //     labelText: 'Sexe',
                      //   ),
                      //   child: DropdownButton<String>(
                      //     hint: Text('Femme'),
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     iconSize: 10,
                      //     elevation:
                      //         5, // change the elevation of the dropdown menu

                      //     dropdownColor: Colors.grey,
                      //     value: dropdownValue,
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         dropdownValue = newValue!;
                      //       });
                      //     },

                      //     items: options
                      //         .map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          hintText: '22',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                      const SizedBox(height: 10),
                      InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          labelText: 'Ville',
                        ),
                        child: DropdownButton<String>(
                          hint: Text('Ariana'),
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
                      const SizedBox(height: 10),
                      // TextFormField(
                      //   controller: _cinController,
                      //   keyboardType: TextInputType.number,
                      //   inputFormatters: [
                      //     FilteringTextInputFormatter.digitsOnly,
                      //     LengthLimitingTextInputFormatter(8),
                      //   ],
                      //   decoration: InputDecoration(
                      //     hintText: '14607665',
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Veuillez entrer votre CIN';
                      //     }

                      //     if (value.length != 8) {
                      //       return 'Veuillez entrer un nombre à 8 chiffres';
                      //     }

                      //     // Autres conditions de validation si nécessaire

                      //     return null; // Retourne null si la valeur est valide
                      //   },
                      // ),
                      
                      TextFormField(
                        controller: _telephoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        decoration: InputDecoration(
                          hintText: '21316547',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'ranyaslouma01@gmail.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Ancien mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                      const SizedBox(height: 10),
                      
                      TextFormField(
                        obscureText: _obscurePassword,
                        //controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Nouveau mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _obscurePassword,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Confirmez mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
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
                       /*  validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la confirmation du mot de passe';
                          } else if (value != _passwordController.text) {
                            return 'La confirmation du mot de passe ne correspond pas';
                          }
                          return null;
                        }, */
                        onSaved: (value) {
                          _confirmPasswordController.text = value!;
                        },
                      ),
                      const SizedBox(height: 15),
                                          ElevatedButton(
                        onPressed: () {
                           if (_formKey.currentState!.validate()) {
                             addUser();

                           Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homeclient()),);
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: Text('Le profile a été modifié avec succès'),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
);
                           }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Changer le rayon selon vos besoins
                          ),
                          fixedSize: Size(120, 40),
                          backgroundColor: Color.fromARGB(255, 28, 68, 248),
                        ),
                        child: Text("Modifier"),
                      ),
                      const SizedBox(height: 20),
                    ])))));
  }
}
