import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'accountE.dart';
import 'addproduct.dart';
import 'indexentreprise.dart';
import 'dart:convert';
import 'listcatag.dart';
import 'listrecmps.dart';
import 'loginent.dart';
import 'modifyproduct.dart';
import 'profile.dart';
import 'dashboard/rapport.dart';
import 'suivreavis.dart';



class Stock extends StatefulWidget {

  
  const Stock({super.key});
  

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
   CollectionReference prodref =FirebaseFirestore.instance.collection("Produit");
 String rech ='';
List <Map <String , dynamic>> data = [];
List <Map <String , dynamic>> recherch = [];

torecherche (String quary) async {
  List <Map <String , dynamic>> result = [];
  if (quary.isEmpty) {
    recherch = result;
  } else {

  }
}

 addData() async {
  for (var element in data) {
    FirebaseFirestore.instance.collection("Produit").add(element);
  }
  print("all data added");
 }
 
@override
void initState(){
  super.initState();
  addData();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
   appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
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
                    onChanged: (val){
              setState(() {
                rech= val;
              });
            },
                    decoration: InputDecoration(
                      suffixIcon: const scanbarcode(),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Recherche...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 31, 81, 248),
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
               color: Color.fromARGB(255, 31, 81, 248),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        bottomNavigationBar: Container(
             color: Color.fromARGB(255, 31, 81, 248),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: GNav(
                  backgroundColor: const Color.fromARGB(255, 31, 81, 248),
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
                          return  ListDash();
                        }));
                      },
                    ),
                    GButton(
                      icon: Icons.perm_identity_rounded,
                      text: 'Profile',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return profile();
                        }));
                      },
                    ),
                  ]),
            )),
      body: StreamBuilder<QuerySnapshot> (
        stream: FirebaseFirestore.instance.collection("Produit").snapshots(),
        builder: (context,snapshots){
           return (snapshots.connectionState == ConnectionState.waiting) 
           ? const Center( child: CircularProgressIndicator(),
           ) : ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context , i) {
              if (rech.isEmpty){
                return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text("code a barre: ${snapshots.data!.docs[i]['code a barre ']}"),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(child: Image.network(snapshots.data!.docs[i]['image'], width: 170,height: 170,),),
                                          const SizedBox(height: 15),
                                          Text("nom : ${snapshots.data!.docs[i]['nom '].toString()}",
                                              style: const TextStyle(fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                           Text(
                                            "code a barre : ${snapshots.data!.docs[i]["code a barre "]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Date d'entree : ${snapshots.data!.docs[i]["Date d'entree"].toDate()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                         
                                          Text(
                                              "Prix d'achat: ${snapshots.data!.docs[i]["Prix d'achat"]} DT",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Prix de vente: ${snapshots.data!.docs[i]["prix de vente"]}DT",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite en stock: ${snapshots.data!.docs[i]["Quantite en stock"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite maximale: ${snapshots.data!.docs[i]["Quantite maximale"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite minimale: ${snapshots.data!.docs[i]["Quantite minimale "]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Description : ${snapshots.data!.docs[i]["Description"]}",
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
                          title:   Text("nom : ${snapshots.data!.docs[i]["nom "]}",
                           style: const TextStyle(fontSize:16,
                                                  fontWeight: FontWeight.w400)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text("code a barre : ${snapshots.data!.docs[i]["code a barre "]}",
                               style: const TextStyle(fontSize:16,
                                                  fontWeight: FontWeight.w400)),
                              const SizedBox(height: 5),
                              Text("Quantité en stock: ${snapshots.data!.docs[i]["Quantite en stock"]}",
                                              style: const TextStyle(fontSize:16,
                                                  fontWeight: FontWeight.w400)),
                            ],
                          ),

                              
                              
                             // Text("Date d'entree : ${snapshots.data!.docs[i]["Date d'entree"]}"),
                             // Text("nom de fournisseur : ${snapshots.data!.docs[i]["Fournisseur"]}"),
                          leading: Image.network(snapshots.data!.docs[i]['image']),    
                            trailing: 
                                   SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) {
                                              return modifyprod(BD: snapshots.data!.docs[i], docsid: snapshots.data!.docs[i].id);
                                            }));
                                          },
                                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
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
                                                                        prodref.doc(snapshots.data!.docs[i].id).delete();
                                           setState(() {
                                             prodref.get();
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
                                                    color: Colors.red)),
                                     
                                      ],
                                    ),
                                   ),
                          ),
                        ));
              }
              else if (snapshots.data!.docs[i]["code a barre "].toString().contains(rech)) {
                 return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text("code a barre: ${snapshots.data!.docs[i]['code a barre ']}"),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(child: Image.network(snapshots.data!.docs[i]['image'], width: 170,height: 170,),),
                                          const SizedBox(height: 15),
                                          Text("nom : ${snapshots.data!.docs[i]['nom '].toString()}",
                                              style: const TextStyle(fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                           Text(
                                            "code a barre : ${snapshots.data!.docs[i]["code a barre "]}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Date d'entrée : ${snapshots.data!.docs[i]["Date d'entree"].toDate()}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                  
                                          Text(
                                              "Prix d'achat: ${snapshots.data!.docs[i]["Prix d'achat"]} DT",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Prix de vente: ${snapshots.data!.docs[i]["prix de vente"]}DT",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite en stock: ${snapshots.data!.docs[i]["Quantite en stock"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite maximale: ${snapshots.data!.docs[i]["Quantite maximale"]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Quantite minimale: ${snapshots.data!.docs[i]["Quantite minimale "]}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 7),
                                          Text(
                                              "Description : ${snapshots.data!.docs[i]["Description"]}",
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
                          title:   Text("nom : ${snapshots.data!.docs[i]["nom "]}"),
                          subtitle: 
                              Text("code a barre : ${snapshots.data!.docs[i]["code a barre "]}"),
                             // Text("Date d'entree : ${snapshots.data!.docs[i]["Date d'entree"]}"),
                             
                          leading: Image.network(snapshots.data!.docs[i]['image']),    
                            trailing: 
                                   SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(builder: (context) {
                                              return modifyprod(BD: snapshots.data!.docs[i], docsid: snapshots.data!.docs[i].id);
                                            }));
                                          },
                                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
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
                                                                        prodref.doc(snapshots.data!.docs[i].id).delete();
                                           setState(() {
                                             prodref.get();
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
                                                    color: Colors.red)),
                                     
                                      ],
                                    ),
                                   ),
                          ),
                        ));
              }
              return Container();
            }
            );
        }
      )
    );
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
        prixint: json["Prix d'achat"],
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
        "Prix d'achat": prixint,
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
