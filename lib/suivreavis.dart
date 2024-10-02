import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accountE.dart';
import 'indexentreprise.dart';
import 'listcatag.dart';
import 'listproduct.dart';
import 'listrecmps.dart';
import 'loginent.dart';
import 'dashboard/rapport.dart';





class suivreavis extends StatefulWidget {
  const suivreavis({super.key});

  @override
  State<suivreavis> createState() => _suivreavisState();
}

class _suivreavisState extends State<suivreavis> {
  CollectionReference avisCollection = FirebaseFirestore.instance.collection('avis');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: avisCollection.get(),
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
                    itemExtent: 80,
                    itemBuilder: (context, i) {
                      return Card(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        child: ListTile(
                          splashColor: Color.fromARGB(255, 34, 34, 34),
                          
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height:5),
                              Text(
                                  "Note : ${list[i]["Note"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height:15),
                              Text(
                                  "Commentaire : ${list[i]["Commentaire"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
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
            'Les avis des clients',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        
       );
  }
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
