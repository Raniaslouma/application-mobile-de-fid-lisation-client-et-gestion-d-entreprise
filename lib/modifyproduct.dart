 import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:date_field/date_field.dart';
import 'dart:io';
import 'dart:async';
import 'listproduct.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class modifyprod extends StatefulWidget {
   final String docsid;
  final BD;
  const modifyprod({Key? key,  required this.docsid, required this.BD}) : super(key: key);

  @override
  State<modifyprod> createState() => _modifyprodState();
}

class _modifyprodState extends State<modifyprod> {
  TextEditingController prixAchatController = TextEditingController();
  TextEditingController prixVenteController = TextEditingController();

 

  void recalculerPrixVente() {
    double prixAchatValue = double.tryParse(prixAchatController.text) ?? 0.0;
    double prixVenteValue = prixAchatValue * 1.2; // Exemple de calcul de prix de vente avec une marge de 20%

    prixVenteController.text = prixVenteValue.toStringAsFixed(2);
  }


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
 String? validatenbr(String? value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    if (double.tryParse(value) == null) {
      return 'Doit être un nombre';
    }
    return null;
  }
  final ImagePicker picker = ImagePicker();
/* Future _imageFromGallery(BuildContext context) async {
    image = await picker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context);
    setState(() {});
  }



  Future _imageFromCamera(BuildContext context) async {
    image = await picker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop(XFile);
    setState(() {});
  }  */
  
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

 
  CollectionReference prodref =FirebaseFirestore.instance.collection("Produit");

  final formstate = GlobalKey<FormState>();

  String? nom, description, fournisseur, code, nbmax,nbmin,nbact,prixint,prixvente;
  DateTime? dateentree;
 XFile? image;
  
  Future _imageFromGallery(BuildContext context) async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      image = pickedFile;
    });
  }
  Navigator.pop(context);
}
Future _imageFromCamera(BuildContext context) async {
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    setState(() {
      image = pickedFile;
    });
  }
  Navigator.of(context).pop(XFile);
}
TextEditingController codeController = TextEditingController();
@override
  void initState() {
    super.initState();
// Initialisez les valeurs des contrôleurs en fonction des données existantes
    prixAchatController.text = widget.BD["Prix d'achat"] == null ? "" : widget.BD["Prix d'achat"].toString();
    recalculerPrixVente();
    // Initialisez les valeurs des contrôleurs en fonction des données existantes
    codeController.text = widget.BD["code a barre "] == null ? "" : widget.BD["code a barre "].toString();
  }

Future<String?> validateCode(String? value) async {
  // Perform your validation logic for the code field
  if (value == null || value.isEmpty) {
    return "Veuillez saisir un nom";
  }

  // Check if an entry with the same code already exists in the database
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('Produit')
      .where('code a barre ', isEqualTo: value)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return "Ce code a barre est déjà utilisé";
  }

  return null;
}




Future updateProduct() async {
  try {
    // Enregistrer l'image sur Firebase Storage
    if (image != null) {
      final fileName = path.basename(image!.path);
      final destination = 'product_images/$fileName';
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child(destination);
      await storageRef.putFile(File(image!.path));
      
      final imageUrl = await storageRef.getDownloadURL();
      
      await prodref.doc(widget.docsid).update({
        "nom ": nom,
                                     "code a barre ": code,

                                     "Description":  description,
                                     "Quantite maximale": nbmax,
                                     "Quantite minimale ": nbmin,
                                     "Quantite en stock": nbact,
                                     "Prix d'achat": prixint,
                                     "prix de vente": prixvente,
                                     "Date d'entree":dateentree,
        "image": imageUrl,
      });
    } else {
      // Si aucune nouvelle image n'a été sélectionnée, mettre à jour les autres champs sans l'image
      await prodref.doc(widget.docsid).update({
         "nom ": nom,
                                     "code a barre ": code,

                                     "Description":  description,
                                     "Quantite maximale": nbmax,
                                     "Quantite minimale ": nbmin,
                                     "Quantite en stock": nbact,
                                     "Prix d'achat": prixint,
                                     "prix de vente": prixvente,
                                     "Date d'entree":dateentree,
      });
    }
    
    print("updated successfully");
   
  } catch (e) {
    debugPrint("Error $e");
  }
}

@override
 Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
            title: const Text(
          "Modifier un produit",
          textAlign: TextAlign.center,
        )),
      body: Container(
         color: Colors.white,
         padding:const EdgeInsets.only(top:20,left:20,right:20),
         child: SingleChildScrollView(
        child: Form (
          key: formstate,
          child: Column(
                  children: [
   GestureDetector(
    onTap:  () => _showOption(context),
  
     child: Container(
                      padding:
                         const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                   
                      height: 200,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                                image:image == null
                            ? NetworkImage(widget.BD["image"])
                            : FileImage(File(image!.path)) as ImageProvider,
                                fit: BoxFit.fill,
                              ),
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 2.0,
                        ),
                      ),
                    ),
   ),
                  const SizedBox(height: 35),
                  TextFormField(
                        initialValue: widget.BD["nom "] == null? "" : widget.BD["nom "].toString(),
                    
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
                        nom = value;
                      },
                   
                  ),
                 const SizedBox(height: 35),

                   TextFormField(
                    /* initialValue: widget.BD["code a barre "] == null
                          ? ""
                          : widget.BD["code a barre "].toString(), */
                           controller: codeController,
                //validator: (String? value) => validateCode(value),


                
                // Autres attributs du champ de saisie du nom
              
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'code a barre du produit',
                      //suffix: scanbarcode(),
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    //validator: validatecodebr,
                     onSaved: (value) {
                        code = value;
                      },
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),

                   DateTimeFormField(
                      initialValue: widget.BD["Date d'entree"] == null ? null : widget.BD["Date d'entree"].toDate(),
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
               /* setState(() {
                  _selectedDate = value;
                });*/
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
                      onSaved: (value) {
                        dateentree = value;
                      },
                      ),
  
                 const SizedBox(height: 35),
                  TextFormField(
                     controller: prixAchatController,
              onChanged: (value) {
                recalculerPrixVente();
              },
                   //  initialValue: widget.BD["Prix d'achat"] == null? "": widget.BD["Prix d'achat"].toString(),
                    
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
                     onSaved: (value) {
                        prixint = value;
                      },
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),
                 

 TextFormField(controller: prixVenteController,
                    // initialValue: widget.BD["prix de vente"] == null? "": widget.BD["prix de vente"].toString(), 
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
                     onSaved: (value) {
                        prixvente = value;
                      },
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),
 TextFormField(
                     initialValue: widget.BD["Quantite maximale"] == null? "": widget.BD["Quantite maximale"].toString(),
                   
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Quantite maximale',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    autocorrect: true,
                    autofocus: true,
                    validator: validatenbr,
                     onSaved: (value) {
                        nbmax = value;
                      },
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),
                  TextFormField(
                    initialValue: widget.BD["Quantite minimale "] == null? "": widget.BD["Quantite minimale "].toString(), 
                    
                    decoration:const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Quantite minimale',
                      hintStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    autocorrect: true,
                    autofocus: true,
                    validator: validatenbr,
                     onSaved: (value) {
                        nbmin = value;
                      },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 35),

                  TextFormField(
                    initialValue: widget.BD["Quantite en stock"] == null? "": widget.BD["Quantite en stock"].toString(), 
                    
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
                     onSaved: (value) {
                        nbact = value;
                      },
                   
                    keyboardType: TextInputType.number,
                  ),
                 const SizedBox(height: 35),

                  TextFormField(
                    initialValue: widget.BD["Description"] == null? "": widget.BD["Description"].toString(), 
                    
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
                        description = value;
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
                                  if (formstate.currentState!.validate()) {
                                    formstate.currentState!.save();
                                   updateProduct();
                                                           
              print("updated succefuly");
               Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Stock()),);
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: Text('Le produit a été modifié avec succès'),
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
                             
                            ],
                          ),
                        const SizedBox(height: 35),
                     
                  ])
    ))));
  }
 
} 
 