/* import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'modifyproduct.dart';

class ConsulterIntervn extends StatefulWidget {
  final docsid;
  const ConsulterIntervn({Key? key, this.docsid}) : super(key: key);
  @override
  _ConsulterIntervnState createState() => _ConsulterIntervnState();
}

class _ConsulterIntervnState extends State<ConsulterIntervn> {

  CollectionReference prodref =
      FirebaseFirestore.instance.collection("Produit");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text("Les Interventions",
            style: TextStyle(color: Colors.white)),
        // actions: [
        //   IconButton(
        //       icon: const Icon(Icons.add_circle_rounded),
        //       onPressed: () {
        //         Navigator.of(context)
        //             .push(MaterialPageRoute(builder: (context) {
        //           return const ConsulterIntervn();
        //         }));
        //       }),
        //   IconButton(
        //       icon: const Icon(Icons.search),
        //       onPressed: (){
        //         Navigator.of(context)
        //             .push(MaterialPageRoute(builder: (context) {
        //           return const Recherche();
        //         }));
        //       }),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: prodref.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> list = [];
                int i = 0;
                for (QueryDocumentSnapshot<Object?> documentSnapshot
                    in snapshot.data!.docs) {
                  // print(documentSnapshot.data().);
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                      list.add(data);

                }
                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: ListTile(
                          splashColor: Colors.grey,
                          title: Text("code a barre : ${list[i]['code a barre'].toString()}",
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Date : ${list[i]["Date"]}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                  "Interventions : ${list[i]["Interventions"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  "Unité : ${list[i]["Unité"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                               /* IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return modifyprod(
                                          BD: snapshot.data!.docs[i],
                                          docsid: snapshot.data!.docs[i].id);
                                    }));
                                  },
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueGrey),
                                ),*/
                                IconButton(
                                  onPressed: () async {
                                    prodref
                                        .doc(snapshot.data!.docs[i].id)
                                        .delete();
                                    setState(() {
                                      prodref.get();
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actions: [
                                                TextButton(onPressed: () {
                                                  Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                  builder: (context) {
                                                  return const ConsulterIntervn();},),);
                                                } ,
                                                child: const Text("OK")),
                                                TextButton(onPressed: (){} , child: const Text("Annuler")),
                                              ],
                                            title: const Text("Succés"),
                                            content: const Text("produit Supprimé avec succes"),
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
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
    this. description,
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
} */