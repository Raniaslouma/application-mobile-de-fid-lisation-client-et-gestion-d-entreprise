import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'indexclient.dart';
import 'loginc.dart';

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreState();
}

class _ParametreState extends State<Parametre> {
  _showOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text("Se déconnecter du compte ?"),
              content: SingleChildScrollView(
                child: Column(children: <Widget>[
                  ListTile(
                      title: Text(
                        "Déconnexion",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Loginclient();
                        }));
                      }),
                  ListTile(
                    title: Text(
                      "Annuler",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Parametre();
                      }));
                    },
                  ),
                ]),
              ),
            )));
  }
Future<void> ajouterAvisEtNotation(double rating, String commentaire) async {
  CollectionReference avisCollection = FirebaseFirestore.instance.collection('avis');
  
  // Créer un document avec un nouvel identifiant automatique
  DocumentReference avisDocRef = await avisCollection.add({
    'Note': rating,
    'Commentaire': commentaire,
  });

  if (avisDocRef.id.isNotEmpty) {
    print('Données de notation et de commentaire enregistrées avec succès');
  } else {
    print("Échec de l'enregistrement des données de notation et de commentaire");
  }
}
 
  @override
  Widget build(BuildContext context) {
    final _dialog = RatingDialog(
      initialRating: 1.0,
      title: Text(
        'Notes et avis',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      message: Text(
        'Appuyez sur une étoile pour définir votre note. Ajoutez plus de description ici si vous le souhaitez.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      image: Icon(Icons.star, color: Colors.yellow, size: 100),
      submitButtonText: 'Envoyer',
      commentHint: 'Définissez votre commentaire ici',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        ajouterAvisEtNotation(response.rating, response.comment);
         showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: Text('Merci pour votre avis . on va prendre en considération tous ce que vous dire .'),
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
      },
    );
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Homeclient();
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(
              horizontal: 100,
              vertical: 10,
            )),
            SizedBox(
              height: 35,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () {
                  
                },
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Profile'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
           Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return Builder(
                        builder: (BuildContext context) {
                          return _dialog;
                        },
                      );
                    },
                  );
                },
                leading: Icon(Icons.star),
                title: Text('Votre avis'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                onTap: () => _showOption(context),
                leading: Icon(Icons.output),
                title: Text('Déconnexion'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
