/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'addproduct.dart';
import 'indexentreprise.dart';
import 'dart:convert';
import 'listcatag.dart';
import 'loginent.dart';
import 'modifyproduct.dart';
import 'profile.dart';
import 'dashboard/rapport.dart';
import 'addrecomp.dart';
import 'listproduct.dart';
import 'suivreavis.dart';
import 'uploadcatalogue.dart';

//import 'modifier_prod.dart';
class liststock extends StatefulWidget {
  const liststock({super.key});

  @override
  State<liststock> createState() => _liststockState();
}

class _liststockState extends State<liststock> {
  CollectionReference prodref =
      FirebaseFirestore.instance.collection("Produit");

  User? user = FirebaseAuth.instance.currentUser;

  String barcodeResult = "";
  List<Map<String, dynamic>> recherch = [];
  List<Map<String, dynamic>> list = [];
  bool loading = false;
  torecherche(String quary) async {
    setState(() {
      loading = true;
    });
    List<Map<String, dynamic>> result = [];
    if (quary.isEmpty) {
      result = list;
    } else {
      result = list
          .where((element) =>
              element['code a barre '].toString().toLowerCase().contains(quary))
          .toList();
    }
    recherch = result;
    recherch = recherch.toSet().toList();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getProduct();

    super.initState();
  }

  void getProduct() {
    setState(() {
      loading = true;
    });
    prodref.get().then((snapshot) {
      for (QueryDocumentSnapshot<Object?> documentSnapshot in snapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        list.add(data);
        list = list.toSet().toList();
        recherch.add(data);
        recherch = recherch.toSet().toList();
      }
      setState(() {
        loading = false;
      });
    });
  }

  Future scanBarcode() async {
    String barcodeResult;

    try {
      barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Annuler",
        true,
        ScanMode.BARCODE,
      );
      setState(() {
        barcodeResult = barcodeResult;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getProductDetails(String barcode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Produit')
        .where('code a barre ', isEqualTo: barcode)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      print(documentSnapshot.data());
    } else {
      return const Text('Aucun produit trouvé.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : recherch.isEmpty
                    ? const Center(child: Text("Il n y a pas des produit"))
                    : ListView.builder(
                        itemCount:
                            recherch.isEmpty ? list.length : recherch.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(" ${recherch[i]['code a barre ']}"),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Image.network(
                                              recherch[i]['image'],
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Text(
                                              "nom : ${recherch[i]['nom '].toString()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                            "code a barre : ${recherch[i]["code a barre "]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Date d'entree : ${recherch[i]["Date d'entree"].toDate()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "nom de fournisseur: ${recherch[i]["Fournisseur"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Prix initiale: ${recherch[i]["prix initiale"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Prix de vente: ${recherch[i]["prix de vente"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite en stock: ${recherch[i]["Quantite en stock"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite maximale: ${recherch[i]["Quantite maximale"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite minimale: ${recherch[i]["Quantite minimale "]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Description : ${recherch[i]["Description"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Card(
                                  child: ListTile(
                                      splashColor: Colors.grey,
                                      title: Text(" ${recherch[i]['nom ']}"),
                                      subtitle: Text(
                                          " ${recherch[i]['Quantite en stock']}"),
                                      leading:
                                          Image.network(recherch[i]['image']),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return modifyprod(
                                                      BD: recherch[i],
                                                      docsid: recherch[i]['id']);
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
                                                                "voulez vous supprimer ce produit ?"),
                                                            content:
                                                                SingleChildScrollView(
                                                                    child: Column(
                                                                        children: <Widget>[
                                                                  ListTile(
                                                                      title:
                                                                          const Text(
                                                                        "Supprimer",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        prodref
                                                                            .doc(list[i]['id'])
                                                                            .delete();
                                                                        setState(
                                                                            () {
                                                                          prodref
                                                                              .get();
                                                                        });
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      }),
                                                                  ListTile(
                                                                    title:
                                                                        const Text(
                                                                      "Annuler",
                                                                      //style: TextStyle(color: Color.fromARGB(255, 90, 92, 94)),
                                                                    ),
                                                                    onTap: () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ])));
                                                      });
                                                },
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.blueGrey)),
                                          ],
                                        ),
                                      ))));
                        })),
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'liste des produits',
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          bottom: PreferredSize(
            //onTap: rechercheprod(),

            preferredSize: const Size(double.infinity, 80),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                  child: TextField(
                    onChanged: torecherche,
                    decoration: InputDecoration(
                      suffixIcon: const scanbarcode(),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Chercher',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onSubmitted: (value) {
                      //  const rechercheproduit();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            builder: (BuildContext context) {
              return const Ajoutproduit();
            },
            context: context,
          ),
          // Action to perform when the button is pressed

          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Container(
            color: Colors.blue,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: GNav(
                  backgroundColor: Colors.blue,
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabActiveBorder: Border.all(color: Colors.white, width: 1.5),
                  gap: 8,
                  onTabChange: (index) {
                    print(index);
                  },
                  padding: const EdgeInsets.all(16),
                  tabs: [
                    GButton(
                      icon: Icons.iso_outlined,
                      text: 'Stock',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Stock();
                        }));
                      },
                    ),
                    GButton(
                      icon: Icons.home,
                      text: 'Accueil',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Homepage();
                        }));
                      },
                    ),
                    GButton(
                      icon: Icons.auto_graph,
                      text: 'Rapports',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return  rapport();
                        }));
                      },
                    ),
                  /*   GButton(
                      icon: Icons.perm_identity_rounded,
                      text: 'Profile',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const profile();
                        }));
                      },
                    ), */
                  ]),
            )));
  }
}

List<Produit> ProduitFromJson(List str) =>
    List<Produit>.from(str.map((x) => Produit.fromJson(x)));

String ProduitToJson(List<Produit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Produit {
  Produit({
    this.nom,
    this.description,
    this.fournisseur,
    this.code,
    this.nbmax,
    this.nbmin,
    this.nbact,
    this.prixint,
    this.prixvente,
    this.dateentree,
    this.image,
  });

  final String? nom;
  final String? description;
  final String? fournisseur;
  final String? code;
  final String? nbmax;
  final String? nbmin;
  final String? nbact;
  final String? prixint;
  final String? prixvente;
  final String? dateentree;
  final String? image;
  factory Produit.fromJson(Map<String, dynamic> json) => Produit(
        nom: json["nom "],
        description: json["Description"],
        fournisseur: json["Fournisseur"],
        code: json["code a barre "],
        nbmax: json["Quantite maximale"],
        nbmin: json["Quantite minimale "],
        nbact: json["Quantite en stock"],
        prixint: json["prix initiale"],
        prixvente: json["prix de vente"],
        dateentree: json["Date d'entree"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "nom ": nom,
        "Description": description,
        "Fournisseur": fournisseur,
        "code a barre ": code,
        "Quantite maximale": nbmax,
        "Quantite minimale ": nbmin,
        "Quantite en stock": nbact,
        "prix initiale": prixint,
        "prix de vente": prixvente,
        "Date d'entree": dateentree,
        "image": image,
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
                      style: TextStyle(color: Colors.blue),
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
        color: Colors.blue,
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
            Text('nom Entreprise',
                style: TextStyle(fontSize: 28, color: Colors.white)),
            Text('nom prenom',
                style: TextStyle(fontSize: 16, color: Colors.white)),
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
              return  rapport();
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
              return const RecompenseEntrep();
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
       /*  ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('Profile'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              var user;
              return const profile();
            }));
          },
        ), */
        ListTile(
          leading: const Icon(Icons.output),
          title: const Text('Déconnexion'),
          onTap: () => _showOption(context),
        )
      ]);
}

class scanbarcode extends StatefulWidget {
  const scanbarcode({super.key});

  @override
  State<scanbarcode> createState() => _scanbarcodeState();
}

class _scanbarcodeState extends State<scanbarcode> {
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    Future scanBarcode() async {
      String scanResult;
      try {
        scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          "Annuler",
          true,
          ScanMode.BARCODE,
        );
        print(scanResult);
      } on PlatformException {
        scanResult = 'failed!';
      }
      if (!mounted) return;
      setState(() => this.scanResult = scanResult);
    }

    return IconButton(
      onPressed: scanBarcode,
      icon: Image.asset(
        'images/scan.png',
      ),
    );
  }
}
 */