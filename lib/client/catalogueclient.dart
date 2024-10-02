import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapplication/client/indexclient.dart';


class CatalogueClient extends StatelessWidget {
  const CatalogueClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Homeclient();
              }));
            },
            icon: CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                          width: 380,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3))
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const OuvrirCatalogue();
                                    }));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'images/catgeo.jpg',
                                      height: 100,
                                      width: 120,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 190,
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Promo géant mai 2023 ',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[700]),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Du 01-05-2023 ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'au 30-06-2023 ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 40),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const OuvrirCatalogue();
                                      }));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.blue[700],
                                          size: 26,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ]))),
                ]))));
  }
}
class OuvrirCatalogue extends StatefulWidget {
  const OuvrirCatalogue({Key? key}) : super(key: key);

  @override
  _OuvrirCatalogueState createState() => _OuvrirCatalogueState();
}

class _OuvrirCatalogueState extends State<OuvrirCatalogue> {
  CollectionReference catalogueCollection =
      FirebaseFirestore.instance.collection('catalogue');

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageWidth = screenWidth *
        0.9; // Augmenter le facteur pour agrandir la largeur des images
    final imageHeight = imageWidth * 1.5; // Ajuster la hauteur en proportion

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CatalogueClient();
            }));
          },
          icon: CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
            ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:50,right:10,left:10),
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
                  List<dynamic> images = list[i]['images'].toList();
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Augmenter le rayon pour agrandir la bordure
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: imageHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 10.0,
                            ),
                            itemBuilder: (context, index) {
                              String imageUrl = images[index];
                              return Container(
                                width: imageWidth,
                                height: imageHeight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Ajuster le rayon pour agrandir la bordure
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
            return const Text("Veuillez vérifier votre connexion.");
          },
        ),
      ),
    );
  }
}