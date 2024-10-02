import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accountE.dart';
import 'indexentreprise.dart';
import 'dart:convert';
import 'listcatag.dart';
import 'listproduct.dart';
import 'modifyrecomp.dart';

import 'loginent.dart';

import 'dashboard/rapport.dart';
import 'addrecomp.dart';
import 'suivreavis.dart';

class listrecomp extends StatefulWidget {
  const listrecomp({super.key});

  @override
  State<listrecomp> createState() => _listrecompState();
}

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
class _listrecompState extends State<listrecomp> {
  CollectionReference recompref =FirebaseFirestore.instance.collection('Recompense');
  @override
  Widget build(BuildContext context) {
     deleteExpiredData();
    return Scaffold(
    body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
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
               
                
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: ListTile(
                          splashColor: Color.fromARGB(255, 0, 0, 0),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Cadeau offert : ${list[i]["offre"]}",
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                const  SizedBox(height:5),
                               Text(
                                  "Type de récompense : ${list[i]["type"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                                   const  SizedBox(height:5),
                                   if (list[i]["type"] == "Points accumulés")
                            Text(
                              "Nombre des points: ${list[i]["points accumulés"]}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const  SizedBox(height:5),
                          if (list[i]["type"] == "Montant d'achat")
                            Text(
                              "Prix achat: ${list[i]["prix d'achat"]} DT",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const  SizedBox(height:5),
                          if (list[i]["type"] == "Nombre des produits")
                          Text(
                              "Nom du produit: ${list[i]["nom produit"]}",
                              style: const TextStyle(fontWeight: FontWeight.bold),),
                              const  SizedBox(height:5),
                          if (list[i]["type"] == "Nombre des produits")
                            Text(
                              "Nombre des produits: ${list[i]["nombre des produit"]}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const  SizedBox(height:5),
                              Text(
                                  "date debut : ${list[i]["dateDebut"].toDate()}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                                   const  SizedBox(height:5),
                              Text(
                                  "date Fin : ${list[i]["dateFin"].toDate()}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                                   const  SizedBox(height:5),
                              Text(
                                  "Description : ${list[i]["Description"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                                   const  SizedBox(height:5),
                            ],
                          ),
                          trailing: SizedBox(
                            height:170,
                            width: 100,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               
                              crossAxisAlignment: CrossAxisAlignment.end,
                              
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Modifyrecomp(
                                                       BD: snapshot.data!.docs[i],
                                          docsid: snapshot.data!.docs[i].id);
                                                }));
                                              },
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blueGrey),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            title: const Text(
                                                                "voulez vous supprimer cette recompense?"),
                                                            content:
                                                                SingleChildScrollView(
                                                                    child: Column(
                                                                        children: <Widget>[
                                                                  ListTile(
                                                                      title:
                                                                          const Text("Supprimer",
                                                                        style: TextStyle(color: Colors.red), ),
                                                                      onTap: () async {recompref
                                                                             .doc(snapshot.data!.docs[i].id)
                                                                             .delete();
                                                                               setState(() {
                                                                             recompref.get();
                                                                              });
                                                                        Navigator.of(context).pop();
                                                                      }),
                                                                  ListTile(
                                                                    title:
                                                                        const Text(
                                                                      "Annuler",
                                                                      //style: TextStyle(color: Color.fromARGB(255, 90, 92, 94)),
                                                                    ),
                                                                    onTap: () {
                                                                      Navigator.of( context) .pop();
                                                                    },
                                                                  ),]))
                                                            
                  );
                },);},
                icon: const Icon(Icons.delete,
                                                    color: Colors.red)
              ),])
                          ),
                        ),
                      );
                    });
              }
              if (snapshot.hasError) {
                // showDialog(
                // context: context,
                // builder: (context) {
                return const AlertDialog(
                  title: Text("Error"),
                  content: Text(""),
                );
                // });
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Text("verifier");
            }),
      ),













   drawer: const NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
          title: const Text(
            'Les récompenses ',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        //boutton add 
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            builder: (BuildContext context) {
              return const RecompenseEntrep();
            },
            context: context,
          ),

          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 31, 81, 248),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),  );
  }
}
List<recompense> recompenseFromJson(List str) =>
    List<recompense>.from(str.map((x) => recompense.fromJson(x)));

String recompenseToJson(List<recompense> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class recompense {
  recompense({
    this.offre,
    this.description,
    this.datedebut,
    this.datefin,
    this.type,
  });

  final String? offre;
  final String? description;
  final String? datedebut;
  final String? datefin;
  final String? type;
  factory recompense.fromJson(Map<String, dynamic> json) => recompense(
        offre: json["offre"],
        description: json["Description"],
        datedebut: json["dateDebut"],
        datefin: json["dateFin"],
       type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "offre": offre,
        "Description": description,
        "dateDebut": datedebut,
        "dateFin": datefin,
        "type": type,
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

