import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'indexentreprise.dart';
import 'loginent.dart';

class Accountent extends StatefulWidget {
  const Accountent({super.key});

  @override
  State<Accountent> createState() => _AccountentState();
}

class _AccountentState extends State<Accountent> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
   final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ancienpasswordController = TextEditingController();

   CollectionReference users =
      FirebaseFirestore.instance.collection('usersEntreprise');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          
          'nom': _nomController.text,
          'prenom': _prenomController.text,
          'telephone': _telephoneController.text,
          'email': _emailController.text,
          'password': _passwordController.text, 
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
            title: const Text(
          "Modifier Profile",
          textAlign: TextAlign.center,
        )),
        body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
                margin:const EdgeInsets.only(top:40),
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
               Image.asset(
                        "images/account.png",
                      ),SizedBox(
                        height: 10,
                      ),
            
                                            TextFormField(
                        controller: _nomController,
                          onSaved: (value) {
                          _nomController.text = value!;
                        },
                        decoration: InputDecoration(
                          
                            hintText: "thouraya",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7)),
                                 enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire vide !";
                          } else {
                            return null;
                          }
                        },
                       
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                         controller: _prenomController,
                          onSaved: (value) {
                          _prenomController.text = value!;
                        },
                        decoration: InputDecoration(
                            hintText: "jamai",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7)),
                                 enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Champ obligatoire vide !";
                          } else {
                            return null;
                          }
                        },
                       
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                         controller: _telephoneController,
                          onSaved: (value) {
                          _telephoneController.text = value!;
                        },
                        decoration: InputDecoration(
                            hintText: "22333000",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7)),
                                 enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),),
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
                       
                        keyboardType: TextInputType.number,
                      ),
 
                      const SizedBox(height: 10),
                      TextFormField(
                         controller: _emailController,
                          onSaved: (value) {
                          _emailController.text = value!;
                        },
                        decoration: InputDecoration(
                            hintText: "thourayajamai.tn@gmail.com",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7)),
                                 enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 2, 111, 219)),
                            borderRadius: BorderRadius.circular(7.0),
                          ),),
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
                      
                        keyboardType: TextInputType.emailAddress,
                      ),
                     
     const SizedBox(height: 10),
                      TextFormField(
                         controller: _ancienpasswordController,
                          onSaved: (value) {
                          _ancienpasswordController.text = value!;
                        },
                        obscureText: _obscurePassword,
                        
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
                       /*  validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe';
                          } else if (value.length < 6) {
                            return 'Le mot de passe doit avoir au moins 6 caractères';
                          } else if (!RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).*$')
                              .hasMatch(value)) {
                            return 'Le mot de passe doit contenir à la fois des chiffres et des lettres';
                          }
                          return null;
                        }, */
                       
                      ),
                      const SizedBox(height: 10),
                      
                      TextFormField(
                          controller: _passwordController,
                          onSaved: (value) {
                          _passwordController.text = value!;
                        },
                        obscureText: _obscurePassword,
                       
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
                       
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _confirmPasswordController,
                          onSaved: (value) {
                          _confirmPasswordController.text = value!;
                        },
                        obscureText: _obscurePassword,
                        
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la confirmation du mot de passe';
                          } 
                          return null;
                        },
                       
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                           if (_formKey.currentState!.validate()) {
                             addUser();

                           Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),);
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
