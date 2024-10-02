import 'package:flutter/material.dart';
import 'indexclient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Recompense extends StatefulWidget {
  const Recompense({Key? key}) : super(key: key);

  @override
  State<Recompense> createState() => _RecompenseState();
}

class _RecompenseState extends State<Recompense> {
  CollectionReference recompref =
      FirebaseFirestore.instance.collection('Recompense');
Future<void> deleteExpiredData() async {
  try {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Perform a Firestore query to retrieve the expired documents
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Recompense')
        .where('dateFin', isLessThanOrEqualTo: now)
        .get();

    // Delete the expired documents
    for (QueryDocumentSnapshot<Object?> documentSnapshot
        in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  } catch (e) {
    // Handle any errors that occur during the deletion process
    print('Error deleting expired data: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    deleteExpiredData();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      body: FutureBuilder<QuerySnapshot>(
        future: recompref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> list = [];
            for (QueryDocumentSnapshot<Object?> documentSnapshot
                in snapshot.data!.docs) {
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              list.add(data);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Récompenses et cadeaux offerts",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Image.asset(
                    'images/recomp.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Nouvelle Récompense',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      var item = list[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cadeau offert : ${item["offre"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                if (item["type"] == "Points accumulés")
                                  Text(
                                    "Nombre de points: ${item["points accumulés"]}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                if (item["type"] == "Montant d'achat")
                                  Text(
                                    "Prix d'achat: ${item["prix d'achat"]} DT",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                if (item["type"] == "Nombre des produits")
                                  SizedBox(height: 8),
                                Text(
                                  "Date début : ${DateFormat('dd/MM/yyyy').format(item["dateDebut"].toDate())}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Date fin : ${DateFormat('dd/MM/yyyy').format(item["dateFin"].toDate())}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Description :",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${item["Description"]}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
