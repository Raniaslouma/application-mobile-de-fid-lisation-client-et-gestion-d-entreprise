// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class profile extends StatefulWidget {
   const profile({super.key});


  //profile({required this.userId});
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
/*    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _nameController;
  late TextEditingController _nomentController;
  bool _isLoading = false;
  late UserData _userData;

  @override
  void initState() {
    super.initState();
    
    getUsers();
  }

 void getUsers() {
  FirebaseFirestore.instance
      .collection('usersEntreprise')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      // Accédez aux données de chaque document ici
      var userId = doc.id;
      var userData = doc.data();
      // Faites ce que vous souhaitez avec les données du document
      print('ID utilisateur : $userId');
      print('Données utilisateur : $userData');
    });
  });
} */

@override
  void initState() {
    print(FirebaseAuth.instance.currentUser!.email);
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des utilisateurs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usersEntreprise').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite : ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Chargement...');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> userData = document.data() as Map<String, dynamic>;

              return  ListTile(
                title: Text(userData['nom entreprise']),
                subtitle: Text(userData['email']),
                onTap: () {
                  // Faites quelque chose lorsque vous cliquez sur un utilisateur
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
