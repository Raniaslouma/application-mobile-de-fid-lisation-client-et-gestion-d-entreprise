import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_field/date_field.dart';
import 'Firebase_api.dart';
import 'listproduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class Ajoutproduit extends StatefulWidget {
  
  const Ajoutproduit({Key? key}) : super(key: key);

  @override
  State<Ajoutproduit> createState() => _Ajoutproduit();
}

class _Ajoutproduit extends State<Ajoutproduit> {
  
  final _formKey = GlobalKey<FormState>();
  final TaskTitle = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final namecontroller = TextEditingController();
  final codecontroller = TextEditingController();
  final nbmaxcontroller = TextEditingController();
  final nbmincontroller = TextEditingController();
  final nbactuelcontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final prixAchatController= TextEditingController();
  final prixVenteController= TextEditingController();
  String? nom, description;
  double? max, min, actuel,code;
  XFile? image;
  //Ajoutproduit({this.nom, this.description, this.max, this.min, this.actuel, this.code});
   var _selectedDate = DateTime.now();
//validator barcode
String? validatecodebr(String? value) {
  if (value == null || value.isEmpty) {
    return 'Le champ est obligatoire';
  }
if (value == 'existing_value') {
        return 'code a barre est deja exist';
      }
  if (int.tryParse(value) == null) {
    return 'Le code à barres doit être un nombre';
  }
  return null;
}
Future<String?> validateCode(String? value) async {
  if (value == null || value.isEmpty) {
    return "Veuillez saisir un code a barre";
  }

  // Check if an entry with the same code already exists in the database
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('Produit')
      .where('code a barre', isEqualTo: int.parse(value))
      .get();

  if (snapshot.docs.isNotEmpty) {
    return "Ce code a barre est déjà utilisé";
  }

  return null;
}



//validator pour les champs numerique
String? validateNmin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    if (double.tryParse(value) == null) {
      return 'le champ Doit être un nombre';
    }
    /*if (double.parse(value) > double.parse(nbmincontroller.text)) {
      return 'Doit être inférieur ou égal à champ2';
    }*/
    return null;
  }
 String? validatenbr(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    if (double.tryParse(value) == null) {
      return 'Doit être un nombre';
    }
    return null;
  }
   /*String? validateValue1(String? value) {
    if (value == null || value.isEmpty) {
      return 'Value 1 is required';
    }
    int? parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Value 1 must be a number';
    }
    if (_value2 != null && parsedValue > _value2!) {
      return 'Value 1 cannot be greater than Value 2';
    }
    if (_value3 != null && (parsedValue < _value2! || parsedValue > _value3!)) {
      return 'Value 1 must be between Value 2 and Value 3';
    }
    return null;
  }*/

 
void mettreAJourPrixVente(String prixAchat) {
  double prixAchatValue = double.tryParse(prixAchat) ?? 0.0;
  double prixVenteValue = prixAchatValue * 1.2; // Exemple : ajouter 20% de marge
  prixVenteController.text = prixVenteValue.toStringAsFixed(2);
}


  Future _imageFromGallery(BuildContext context) async {
    image = await picker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
    setState(() {});
  }

  Future _imageFromCamera(BuildContext context) async {
    image = await picker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop(XFile);
    setState(() {});
  }
  _showOption(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("choix"),
              content: SingleChildScrollView(
                child: Column(children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text("Gallery"),
                    onTap: () => _imageFromGallery(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Camera"),
                    onTap: () => _imageFromCamera(context),
                  ),
                ]),
              ),
            )));
  }



CollectionReference productCollection = FirebaseFirestore.instance.collection('Produit');
Future<void> addProduct()async {
     final destination = 'images/${image!.name}';

    final task =FirebaseApi.uploadFile(destination,File(image!.path));
     setState(() {  });
      if (task == null ) return;
       final snapshot = await task.whenComplete(() {});
       final urlDownload = await snapshot.ref.getDownloadURL();

       print(' Download-Link : $urlDownload');
      return productCollection
          .add({
        
             'nom ': namecontroller.text,
          'code a barre ': codecontroller.text,
          "Date d'entree": _selectedDate,
          'Quantite en stock': nbactuelcontroller.text,
          'Description':descriptioncontroller.text,
           'Quantite maximale':nbmaxcontroller.text,
          'Quantite minimale ': nbmincontroller.text,
          "Prix d'achat":prixAchatController.text,
          'prix de vente':prixVenteController.text,
          "image":urlDownload
          })
          .then((value) {
      print('Produit ajouté avec succès!');
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Produit ajouté avec succès!')),
      );
    })
          .catchError((error) {
      print('Erreur lors de l\'ajout du produit: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du produit: $error')),
      );
    });
    }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
            title: const Text(
          "Ajouter un produit",
          textAlign: TextAlign.center,
        )),
        body: Container(
          color: Colors.white,
         padding:const EdgeInsets.only(top:20,left:20,right:20),
         child: Form(
            key: _formKey,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(children: [
                  Container(
                    padding:
                       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                    child: IconButton(
                      onPressed: () => _showOption(context),
                       icon: Icon(
                        Icons.camera_alt,
                        size: 50.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    height: 200,
                    width: 100,
                    decoration: BoxDecoration(
                      image: image == null
                          ? null
                          : DecorationImage(
                              image: FileImage(File(image!.path)),
                              fit: BoxFit.fill,
                            ),
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  TextFormField(
                    controller:namecontroller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Nom produit',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champ obligatoire vide !';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      namecontroller.text = value!;
                    },
                  ),
                 const SizedBox(height: 35),

                  TextFormField(
                    controller:codecontroller,
                    decoration:  InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'code a barre produit',
                      suffix: IconButton(
      onPressed: () async{
        String  scanResult;
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
      setState(() {
        codecontroller.text = scanResult;
      });
   
      },
      icon: Image.asset(
        'images/scan.png',
      ),
    ),
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  // validator: (String? value) => validateCode(value),




                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 35),
                 DateTimeFormField(
                    
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: "Date d'entrée",
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
               onDateSelected: (DateTime value) {
                setState(() {
                  _selectedDate = value;
                });
              },
                     validator: (DateTime ?dateTime) {
             if (dateTime == null) {
              return 'Veuillez sélectionner une date.';
            } 
           /* if (dateTime.isBefore(DateTime.now())) {
              return 'La date doit être ultérieure à la date actuelle.';
            }*/
            return null;
          },
                     // onDateSelected: (DateTime value) {
                       // print(value);
                     // }
                      ),

                 const SizedBox(height: 35),
                                    TextFormField(
                    controller:prixAchatController,
                     onChanged: (value) {
    // Appeler la fonction pour mettre à jour le prix de vente automatiquement
    mettreAJourPrixVente(value);
  },
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Prix d'achat",
                      suffixText: ' DT',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    autocorrect: true,
                    autofocus: true,
                    validator: validatenbr,
                    keyboardType: TextInputType.number,
                  ),
                 

                 const SizedBox(height: 35),

 TextFormField(
                    controller:prixVenteController,
                    enabled: false,
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'prix de vente',
                      suffixText: ' DT',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    autocorrect: true,
                    autofocus: true,
                    validator: validatenbr,
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),

                TextFormField(
                    controller:nbactuelcontroller,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Quantite en stock',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champ obligatoire vide !';
                      }
                      return null;
                    },
                   
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),
                  TextFormField(
                    controller:nbmaxcontroller,
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Quantité maximale',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    autocorrect: true,
                    autofocus: true,
                    validator: validatenbr,
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),

                  TextFormField(
                    controller:nbmincontroller,
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Quantité minimale',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    autocorrect: true,
                    autofocus: true,
                    validator: validateNmin,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 35),

                  TextFormField(
                    controller:descriptioncontroller,
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Description',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champ obligatoire vide !';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      descriptioncontroller.text = value!;
                    },
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    autofocus: true,
                  ),
                 const SizedBox(height: 50),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Stock();
                            }));
                          },
                          
                                  style: ElevatedButton.styleFrom(
      fixedSize: const Size(120, 50),
      backgroundColor:
                                  Color.fromARGB(255, 77, 78, 80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Match the outer ClipRRect radius
      ),
    ),
                                  
                          child: const Text("Annuler"),
                        ),

                        ElevatedButton(
                          
                          onPressed: () {
                            
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();
                            addProduct();
                             
              print("created succefuly");
               Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Stock()),);
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: Text('Le produit a été ajouté avec succès'),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  },
);
    }
                          },
                           style: ElevatedButton.styleFrom(
      fixedSize: const Size(120, 50),
      backgroundColor: const Color.fromARGB(255, 31, 81, 248),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Match the outer ClipRRect radius
      ),
    ),
                                  
                          child: const Text("Enregistrer"),
                        ),

                      ]),
                 const SizedBox(height: 35),
                ])))));
  }}

