import 'package:flutter/material.dart';
import 'package:myapplication/client/addcarte.dart';
import 'package:myapplication/client/catalogueclient.dart';
import 'package:myapplication/client/listentrep.dart';
import 'package:myapplication/client/map.dart';
import 'package:myapplication/client/parametre.dart';
import 'package:myapplication/client/recompense.dart';
import 'accountC.dart';


class Homeclient extends StatefulWidget {
  const Homeclient({super.key});

  @override
  State<Homeclient> createState() => _HomeclientState();
}

class _HomeclientState extends State<Homeclient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
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
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ListEntreprise();
                        }));
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ModifierProfile();
                        }));},
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    'Bienvenue, \n  à espace Géant',
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
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,//
                  children: const [
                    Text(
                      'Explorer les catégories',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: categorieslist.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              return Categorclient(
                categories: categorieslist[index],
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBar(),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _currentIndex = 0;

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 1) {
      // Ouvrir la page "Paramètres" lors du clic sur l'élément de la barre de navigation
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Parametre(); // Remplacez Parametre() par le nom de votre classe de page "Paramètres"
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChange,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}

class Categorclient extends StatelessWidget {
  final Categories categories;
  const Categorclient({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return categories.view;
        }));
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 4.0,
                  spreadRadius: .05,
                ),
              ]),
          child: Column(
            children: [
              Align(
                child: Image.asset(
                  categories.imagepath,
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                categories.nameclient,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.6)),
              )
            ],
          )),
    );
  }
}
class Categories {
  String imagepath;
  String nameclient;
  Widget view;

  Categories({
    required this.nameclient,
    required this.imagepath,
    required this.view,
  });
}

List<Categories> categorieslist = [
  Categories(
    view: const Ajoutcarte(),
    nameclient: 'Carte',
    imagepath: 'images/cartefidelite.png',
  ),
  Categories(
    view: const CatalogueClient(),
    nameclient: 'Catalogue',
    imagepath: 'images/catalogueclient.png',
  ),
  Categories(
    view: const Recompense(),
    nameclient: 'Recompenses',
    imagepath: 'images/12345.png',
  ),
  Categories(
    view: const GMapsyr(),
    nameclient: 'Map',
    imagepath: 'images/map2.png',
  ),
];
