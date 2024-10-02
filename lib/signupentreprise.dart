import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'indexentreprise.dart';
import 'loginent.dart';

class Signupent extends StatefulWidget {
  const Signupent({super.key});

  @override
  State<Signupent> createState() => _SignupentState();
}

class _SignupentState extends State<Signupent> {
  final _formKey = GlobalKey<FormState>();
  
  //les controlleurs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _cinController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
List<String> Entreprises = []; // Liste pour stocker les choix récupérés depuis Firebase
  String? _selectedChoice; // Variable pour stocker le choix sélectionné
bool _obscurePassword = true;
  @override
  void initState() {
    super.initState();
    _fetchEntreprises(); // Appeler la fonction pour récupérer les choix depuis Firebase
  }

  void _fetchEntreprises() {
    FirebaseFirestore.instance
        .collection('Entreprises')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        Entreprises = querySnapshot.docs.map((doc) => doc['nomEntreprise'] as String).toList();
      });
    }).catchError((error) {
      print('Erreur lors de la récupération des choix depuis Firebase: $error');
    });
  }
  

 Future <void> validateMatricule(String nomEntreprise, String matricule) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Employes')
      .where('matricule', isEqualTo: matricule)
      .where('nomEntreprise', isEqualTo:nomEntreprise )
      .get();

  if (querySnapshot.docs.isEmpty) {
    // Le matricule n'existe pas pour l'entreprise sélectionnée
    print('Matricule invalide');
    setState(() {
      matExist = false;
    });
  } else{
    print('Matricule valide');

    setState(() {
      matExist = true;
    });
  }
}

  CollectionReference users =
      FirebaseFirestore.instance.collection('usersEntreprise');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'nom entreprise': _selectedChoice,
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'telephone': _telephoneController.text,
          'cin': _cinController.text,
          'matricule': _matriculeController.text,
          'email': _emailController.text,
          'password': _passwordController.text, 
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
bool matExist=false;
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
                                fontSize: 27,
                                color: Color.fromARGB(255, 83, 83, 83),
                                fontWeight: FontWeight.w600)),
                      ),
                      Image.asset("images/login.jpg", width: 300, height: 300),

                       DropdownButtonFormField<String>(
                        
              value: _selectedChoice,
              items: Entreprises.map((String choice) {
                return DropdownMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedChoice = newValue;
                });
              },
              decoration: InputDecoration(
                 labelText: "nom d'entreprise",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ), 
                        autofocus: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire vide !";
                          } else {
                            return null;
                          }
                        },
            ),
            
            /* Text(
              "nom d'entreprise: ${_selectedChoice ?? 'Aucun choix'}",
              style: TextStyle(fontSize: 16.0),
            ), */
                   
                      const SizedBox(height: 15),
                                            TextFormField(
                        controller: _nomController,
                        decoration: InputDecoration(
                            hintText: "Nom",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire vide !";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _nomController.text = value!;
                        },
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _prenomController,
                        decoration: InputDecoration(
                            hintText: "Prénom",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire vide !";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _prenomController.text = value!;
                        },
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _telephoneController,
                        decoration: InputDecoration(
                            hintText: "téléphone",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire vide !";
                          }
                          if (value.length != 8) {
                            return 'Veuillez entrer 8 chiffres';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _telephoneController.text = value!;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _cinController,
                        decoration: InputDecoration(
                            hintText: "CIN",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire vide !";
                          }
                          if (value.length != 8) {
                            return 'Veuillez entrer 8 chiffres';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _cinController.text = value!;
                        },
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _matriculeController,
                        decoration: InputDecoration(
                            hintText: "Matricule",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7))),
                                onChanged: (value) async{
                              print("test");
  validateMatricule(_selectedChoice!, _matriculeController.text);

                                },
                       validator: (value) {
  if (value!.isEmpty) {
    return "Champ obligatoire vide !";
  }

  if (_selectedChoice == null) {
    return "Sélectionnez d'abord une entreprise !";
  }
  if (matExist == false) {
    return "cette matricule ne correspond pas a cette entreprise";
    
  }

  // Valider le matricule en utilisant la fonction validateMatricule
  

  return null;
},

                        onSaved: (value) {
                          _matriculeController.text = value!;
                        },
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            hintText: "E-mail",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ obligatoire vide !";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-].[a-z]")
                              .hasMatch(value)) {
                            return ("entrer un e-mail valide!");
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _emailController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
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
                      const SizedBox(height: 30),
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
                                    builder: (context) => const Homepage()),
                              );
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(120, 50),
                            backgroundColor:
                                const Color.fromARGB(255, 26, 64, 233)),
                        child: const Text("s'inscrire"),
                      ),

                      const SizedBox(height: 17),

                      Text.rich(
                        TextSpan(
                          text: "si vous avez déja un compte?",style:const TextStyle(fontSize: 16,),
                          children: [
                            TextSpan(
                                text: "se connecter",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 31, 81, 248),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const loginent()),
                                    );
                                  }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ])))));
  }
}

 
          