import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../mdpoublie.dart';
import 'listentrep.dart';
import 'signupclient.dart';

class Loginclient extends StatefulWidget {
  const Loginclient({super.key});
  @override
  State<Loginclient> createState() => _LoginclientState();
}

class _LoginclientState extends State<Loginclient> {
  bool visible = false;
  bool _obscurePassword = true;
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
                child: Form(
                  key: _formkey,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text("Se Connecter",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 83, 83, 83),
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 8),
                    Image.asset("images/login.jpg", width: 300, height: 300),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
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
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
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
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "le mot de passe ne peut pas être vide!";
                        }
                        if (!regex.hasMatch(value)) {
                          return ("entrer un mot de passe valide! ");
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ResetPasswordPage()));
                        },
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text('Mot de passe oublié ?'),
                        )),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          try {
                            // Vérifier si l'utilisateur existe
                            final UserCredential userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ListEntreprise()),
                              (route) => false,
                            );
                            // Connecter l'utilisateur
                            final User? user = userCredential.user;
                            print(
                                'Utilisateur connecté avec l\'ID : ${user?.uid}');
                          } on FirebaseAuthException catch (e) {
                            print('error : ${e.code}');
                            if (e.code == 'user-not-found' ||
                                e.code == 'unknown') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Aucun utilisateur trouvé pour cet e-mail.')));
                            } else if (e.code == 'Wrong password ') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('mot de passe incorrect')));
                            }
                          }

                          print("test");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(120, 50),
                          backgroundColor:
                              const Color.fromARGB(255, 26, 64, 233)),
                      child: const Text("Connexion"),
                    ),
                    const SizedBox(height: 30),
                    Text.rich(
                      TextSpan(
                        text: "si vous n'avez pas un compte?",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                              text: "S'inscrire",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 31, 81, 248),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const signupclientPage()),
                                  );
                                }),
                        ],
                      ),
                    )
                  ]),
                ))));
  }
}
