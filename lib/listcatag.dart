import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accountE.dart';
import 'indexentreprise.dart';
import 'dart:convert';
import 'listrecmps.dart';
import 'loginent.dart';
import 'modifycatag.dart';
import 'dashboard/rapport.dart';
import 'listproduct.dart';
import 'suivreavis.dart';
import 'uploadcatalogue.dart';



class Catalogue extends StatefulWidget {
  const Catalogue({super.key});

  @override
  State<Catalogue> createState() => _CatalogueState();
}class _CatalogueState extends State<Catalogue> {
  CollectionReference catalogueCollection =
      FirebaseFirestore.instance.collection('catalogue');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<QuerySnapshot>(
          future: catalogueCollection.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> list = [];
              for (QueryDocumentSnapshot documentSnapshot
                  in snapshot.data!.docs) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                list.add(data);
              }
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  List<dynamic> images = list[i]['images'];
                  return Card(
                    child: ListTile(
                      splashColor: Colors.grey,
                      title: Text(
                        "titre : ${list[i]['titre'].toString()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              String imageUrl = images[index];
                              return Image.network(imageUrl);
                            },
                          ),
                          Text(
                            "date debut : ${list[i]["date debut"].toDate()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "date Fin : ${list[i]["dateFin"].toDate()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Description : ${list[i]["Description"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return modifycatalogue(
                                      BD: snapshot.data!.docs[i],
                                      docsid: snapshot.data!.docs[i].id,
                                    );
                                  },
                                ));
                              },
                              icon: const Icon(Icons.edit, color: Colors.blueGrey),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("voulez vous supprimer ce catalogue ?"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              title: const Text(
                                                "Supprimer",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                              onTap: () async {
                                                catalogueCollection
                                                    .doc(snapshot.data!.docs[i].id)
                                                    .delete();
                                                setState(() {
                                                  catalogueCollection.get();
                                                });
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const Uploadcatalogue(),
                                                  ),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              title: const Text(
                                                "Annuler",
                                                //style: TextStyle(color: Color.fromARGB(255, 90, 92, 94)),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            if (snapshot.hasError) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text(""),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Text("verifier");
          },
        ),
      ),
   








   drawer: const NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
          title: const Text(
            'Catalogue de promotion',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
       );
  }
}

List<Catalogues> CataloguesFromJson(List str) =>
    List<Catalogues>.from(str.map((x) => Catalogues.fromJson(x)));

String CataloguesToJson(List<Catalogues> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Catalogues {
  Catalogues({
    this.titre,
    this.description,
    this.datedebut,
    this.datefin,
    this.file,
  });

  final String? titre;
  final String? description;
  final String? datedebut;
  final String? datefin;
  final String? file;
  factory Catalogues.fromJson(Map<String, dynamic> json) => Catalogues(
        titre: json["titre"],
        description: json["Description"],
        datedebut: json["date debut"],
        datefin: json["dateFin"],
        file: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "titre ": titre,
        "Description": description,
        "date debut": datedebut,
        "dateFin": datefin,
        "images": file,
      };
}
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});
  _showOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
              content: SingleChildScrollView(
                child: Column(children: <Widget>[
                  ListTile(
                      title: const Text(
                        "Déconnexion",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () async {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const loginent()),
                          (route) => false,
                        );
                        // await FirebaseAuth.instance.signOut();
                      }),
                  ListTile(
                    title: const Text(
                      "Annuler",
                      style: TextStyle(color: Color.fromARGB(255, 94, 93, 93)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        color: Color.fromARGB(255, 31, 81, 248),
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: const Column(
          children: [
            CircleAvatar(
              radius: 52,
              child: Icon(
                Icons.perm_identity_rounded,
                color: Colors.white,
                size: 60,
              ),
            ),
            SizedBox(height: 12),
           ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text('Accueil'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Homepage();
            }));
          },
        ),
        ListTile(
          leading: Container(
            child: Image.asset('images/rapport.png'),
          ),
          title: const Text('visualisation du vente'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return  ListDash();
            }));
          },
        ),
        ListTile(
          leading: const Icon(Icons.iso_outlined),
          title: const Text('Gestion de Stock'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Stock();
            }));
          },
        ),
        ListTile(
          leading: Container(
            child: Image.asset('images/catalogue.png'),
          ),
          title: const Text('Catalogue de promotion'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Catalogue();
            }));
          },
        ),
        ListTile(
          leading: const Icon(Icons.card_giftcard),
          title: const Text('Les récompenses et les cadeaux offerts'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const listrecomp();
            }));
          },
        ),
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Suivre les avis des clients'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const suivreavis();
            }));
          },
        ),
        const Divider(color: Colors.black54),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('Profile'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              
              return  Accountent();
            }));
          },
        ),
        ListTile(
          leading: const Icon(Icons.output),
          title: const Text('Déconnexion'),
          onTap: () => _showOption(context),
        )
      ]);
}
