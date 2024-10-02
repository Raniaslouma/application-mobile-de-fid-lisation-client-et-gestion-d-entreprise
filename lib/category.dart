import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'accountE.dart';
import 'listproduct.dart';
import 'listrecmps.dart';

import 'dashboard/rapport.dart';
import 'suivreavis.dart';

import 'uploadcatalogue.dart';

class Category {
  String thumbnail;
  String name;
  Widget view;

  Category({required this.name, required this.thumbnail, required this.view});
}
User? user = FirebaseAuth.instance.currentUser;
List<Category> categoryList = [
  Category(
    view:  ListDash(),
    name: ' Visualisation de vente',
    thumbnail: 'images/rapporthp.png',
  ),
  Category(
    view: const Stock(),
    name: 'Gestion de stock         ',
    thumbnail: 'images/stock.png',
  ),
  Category(
    view: const Uploadcatalogue(),
    name: 'Catalogue de promotion',
    thumbnail: 'images/cataloguehp.png',
  ),
  Category(
    
    view:  Accountent(),
    name: 'Profile    ',
    thumbnail: 'images/profile.png',
  ),
   Category(
    view: const suivreavis(),
    name: ' Suivre les avis des clients',
    thumbnail: 'images/avis1.png',
  ),
   Category(
    
    view:  listrecomp(),
    name: 'Les récompenses et les cadeaux offerts',
    thumbnail: 'images/y.jpg',
  ),
 
];
