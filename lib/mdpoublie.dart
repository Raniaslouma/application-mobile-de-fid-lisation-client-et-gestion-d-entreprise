import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  String _errorMessage = '';

  Future<void> _resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _errorMessage =
            'Instructions de réinitialisation envoyées à votre adresse e-mail.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'La réinitialisation du mot de passe a échoué.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 81, 248),
        title: const Text('Réinitialisation de mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:40,left:20,right:20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez saisir une adresse e-mail.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _resetPassword();
                  }
                },
                 style: ElevatedButton.styleFrom(
                          fixedSize: const Size(170, 50),
                          backgroundColor:
                              const Color.fromARGB(255, 26, 64, 233)),
                child: const Text('Réinitialiser le mot de passe'),
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
