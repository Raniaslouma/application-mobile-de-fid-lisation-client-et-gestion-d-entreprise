import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myapplication/helepers/cachehelpers.dart';

class Info extends StatelessWidget {
  final Map<String, dynamic> carteInformations;
  final Map<String, dynamic> historiqueClient;
  final String codeCarteSaisi;
  final VoidCallback masquerFormulaire;
  const Info({
    Key? key,
    required this.carteInformations,
    required this.historiqueClient,
    required this.codeCarteSaisi,
    required this.masquerFormulaire,
    required void Function() supprimerInfoCarte,
  }) : super(key: key);

  void supprimerPage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la carte'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer votre carte ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                masquerFormulaire(); // Utilisation de la fonction de rappel pour masquer le formulaire
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Info de votre carte",
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Image.network(
                  carteInformations['image'] ?? '',
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  ' ${carteInformations['code']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Nom: ${carteInformations['nom']}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Date d\'expiration: ${carteInformations['date_expiration']}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 1,
                color: Colors.blue[700],
              ),
              const SizedBox(height: 10),
              Text(
                'Vos Points de fidélité : ${carteInformations['point']}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              const Divider(
                color: Colors.blue,
                height: 20,
                thickness: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                'Votre Historique d\'achat:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Historique')
                    .where('carteId', isEqualTo: codeCarteSaisi)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text(
                        'Une erreur s\'est produite : ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Aucun historique disponible',
                        style: TextStyle(
                          color: Colors.pink[700],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  var querySnapshot = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, index) {
                      var historiqueData = querySnapshot.docs[index].data()
                          as Map<String, dynamic>;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nom du produit: ${historiqueData['nomProduit'] ?? ''}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Nombre des produits: ${historiqueData['nomberdeproduit'] ?? ''}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Prix: ${historiqueData['prix'] ?? ''} DT',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Date: ${historiqueData['date'] != null ? DateFormat('yyyy-MM-dd').format(historiqueData['date'].toDate()) : ''}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: FloatingActionButton(
                  onPressed: () {
                    supprimerPage(context);
                    CacheHelper.clearCache();
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
