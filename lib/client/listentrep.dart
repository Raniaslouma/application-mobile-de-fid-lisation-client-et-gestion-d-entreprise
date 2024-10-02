import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'indexclient.dart';
import 'indexclientmg.dart';



class ListEntreprise extends StatefulWidget {
  const ListEntreprise({super.key});

  @override
  State<ListEntreprise> createState() => _ListEntrepriseState();
}

class _ListEntrepriseState extends State<ListEntreprise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // Padding(
               // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
               Container(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                  
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  //padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    'Bienvenue !',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
             // ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "Liste des entreprises",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            ],
          ),
          ItemWidget(),
        ],
      ),
    );
  }
}
class ItemWidget extends StatelessWidget {
  const ItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            //for (int i = 0; i < 2; i++)//
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                    width: 380,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Homeclient();
                              }));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'images/geant-logo1.jpg',
                                height: 85,
                                width: 85,
                              ),
                            ),
                          ),
                          Container(
                            width: 190,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Espace Géant',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Homeclient();
                                }));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]))),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                    width: 380,
                    height: 75,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Homeclientmg();
                              }));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'images/Logo-MG1.jpg',
                                height: 90,
                                width: 90,
                              ),
                            ),
                          ),
                          Container(
                            width: 190,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Espace Mg',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Homeclientmg();
                                }));
                              },
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 26,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]))),
          ],
        ),
      ),
    );
  }
}
