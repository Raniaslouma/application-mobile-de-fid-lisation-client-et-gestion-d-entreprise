import 'dart:io';
import 'dart:async';
import 'package:date_field/date_field.dart';
import 'package:myapplication/listcatag.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Firebase_api.dart';
import 'package:intl/intl.dart';
import 'button_widget.dart';
import 'listproduct.dart';


class Uploadcatalogue extends StatefulWidget {
  const Uploadcatalogue({Key? key}) : super(key: key);

  @override
  State<Uploadcatalogue> createState() => _UploadcatalogueState();
}

class _UploadcatalogueState extends State<Uploadcatalogue> {
  bool isAffiche = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('catalogue').snapshots(),
     builder: (context, snapshot) {
  if (snapshot.hasData) {
    final files = snapshot.data!.docs;

    if (files.isEmpty) {
      // Aucun catalogue trouvé, afficher l'interface d'ajout
      return const addcatalogue();
    } else {
      final now = DateTime.now();
      final fileData = files.first.data();

      if (((fileData as Map<String, dynamic>)['dateFin'] as Timestamp).toDate().isBefore(now)) {
        // Date de fin dépassée, afficher l'interface d'ajout
        return const addcatalogue();
      } else {
        // Date de fin non dépassée, afficher l'interface de visualisation
        return Catalogue();
      }
    }
  } else {
    return const Center(child: CircularProgressIndicator());
  }
},

      
    );
  }
} 


class addcatalogue extends StatefulWidget {
  const addcatalogue({super.key});

  @override
  State<addcatalogue> createState() => _addcatalogueState();
}

class _addcatalogueState extends State<addcatalogue> {
final _formKey = GlobalKey<FormState>();
final titreController = TextEditingController();
final descriptionController = TextEditingController();
DateTime? dateDebut = DateFormat("yyyy-MM-dd").parse("2023-05-01");
DateTime? dateFin = DateFormat("yyyy-MM-dd").parse("2023-05-06");
  PlatformFile? pickedFile;
  UploadTask? task;
  File? file;
  
List<File> imageFiles = [];
List<String> imageUrls = [];

CollectionReference catalogueCollection = FirebaseFirestore.instance.collection('catalogue');

/* Future<void> addCatalogue() async {
  for (int i = 0; i < imageFiles.length; i++) {
  File file = imageFiles[i];
  String fileName = fileNames[i];
  
  final destination = 'Catalogue/$fileName';

  task = FirebaseApi.uploadFile(destination, file);
  setState(() {});
  
  if (task == null) return;
  
  final snapshot = await task!.whenComplete(() {});
  final urlDownload = await snapshot.ref.getDownloadURL();

  print('Download-Link: $urlDownload');
  
  // Store the image URL in Firestore
  await catalogueCollection.add({
    'titre': titreController.text,
    'Description': descriptionController.text,
    'date debut': dateDebut,
    'dateFin': dateFin,
    'fichier': urlDownload,
  });
}

  print("Catalogues added");
}
     */
Future<void> addCatalogue() async {
  List<String> imageUrls = []; // Liste des URLs de téléchargement des images

  for (File file in imageFiles) {
    final fileName = basename(file.path);
    final destination = 'Catalogue/$fileName';
    final snapshot = await FirebaseApi.uploadFile(destination, file);
    final urlDownload = await snapshot!.ref.getDownloadURL();

    imageUrls.add(urlDownload); // Ajouter l'URL à la liste des URLs des images
  }

  // Créer un seul document avec les informations et la liste des URLs des images
  await catalogueCollection.add({
    'titre': titreController.text,
    'Description': descriptionController.text,
    'date debut': dateDebut,
    'dateFin': dateFin,
    'images': imageUrls, // Ajouter la liste des URLs des images
  });

  print('Images enregistrées dans un seul document');
}


  

Future<String?> validateUniqueDate(DateTime? dateTime) async {
  if (dateTime == null) {
    return 'Veuillez sélectionner une date.';
  }
  final snapshot = await FirebaseFirestore.instance
      .collection('catalogue')
      .where('date debut', isEqualTo: dateTime)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return 'La date sélectionnée existe déjà.';
  }

  return null;
}

      @override
    Widget build(BuildContext context) {
      
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 31, 81, 248),
            title: const Text(" Ajouter un catalogue ",
            textAlign: TextAlign.center,)
          ),
           body : Container(
           color: Colors.white,
                
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
         child: Form(
            key: _formKey,
            child: GestureDetector(
                child: ListView(children: [
                  SingleChildScrollView(
                  child:Container(
                    
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                    padding:
                       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                       child:Column(children:[
                        ButtonWidget(
                onClicked: selectFile,
                icon: Icons.arrow_circle_up_outlined ,
                text :'Selectionner un fichier',
               ),
                 const SizedBox(height: 10),
               
Text(
  fileNames.join('\n'),
  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),

               const SizedBox(height: 20),
               task !=null ? buildUploadStatus(task!) : Container(),
                 
                       ]),),),
      const SizedBox(height: 35),


             TextFormField(
                    controller:titreController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Titre',
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
                      titreController.text = value!;
                    },
                  ),
                   const SizedBox(height: 35),

                  TextFormField(
                    controller:descriptionController,
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
                      descriptionController.text = value!;
                    },
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    autofocus: true,
                  ),
                 const SizedBox(height: 35),
                 DateTimeFormField(
                    
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: "Date debut",
                      ),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      autovalidateMode: AutovalidateMode.always,
               onDateSelected: (DateTime value) {
                setState(() {
                  dateDebut = value;
                });
              },
                     /* validator: (DateTime ?dateTime) {
            if (dateTime == null) {
              return 'Veuillez sélectionner une date.';
            }
            if (dateDebut == 'existing_value') {
        return 'il existe un catalogue qui debut dans ce date !';
      }
           /* if (dateTime.isBefore(DateTime.now())) {
              return 'La date doit être ultérieure à la date actuelle.';
            }*/
            return null;
          } */   ),
const SizedBox(height: 35),
                 DateTimeFormField(
                    
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: "Date fin",
                      ),
                      mode: DateTimeFieldPickerMode.dateAndTime,
                      autovalidateMode: AutovalidateMode.always,
               onDateSelected: (DateTime value) {
                setState(() {
                  dateFin = value;
                });
              },
                    /*  validator: (DateTime ?dateTime) {
            if (dateTime == null) {
              return 'Veuillez sélectionner une date.';
            }
            if (dateDebut!.isAfter(dateFin!)) {
              return 'La date fin doit être ultérieure à la date debut';
            }
             if (dateTime == 'existing_value') {
        return 'il existe un catalogue qui finit dans ce date !';
      }
            return null;
          }, */
                      ),

                 const SizedBox(height: 60),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const Stock();
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
                             addCatalogue();
              print("created succefuly");
               Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Catalogue()),);
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: const Text('Le catalogue a été ajouté avec succès'),
      actions: [
        TextButton(
          child: const Text('OK'),
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
            ],
            ),
          ),
         ),
        ));
    }



String fileName = 'Pas de fichier';
List<String> fileNames = [];


Future<void> selectFile() async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
  if (result == null) {
    return;
  }
  
  final filePaths = result.files.map((file) => file.path!).toList();
  
  setState(() {
    imageFiles = filePaths.map((path) => File(path)).toList();
    fileNames = filePaths.map((path) => basename(path)).toList(); // Mettre à jour les noms des fichiers
  });
}



  Widget buildUploadStatus(UploadTask task ) => StreamBuilder<TaskSnapshot> (
    stream : task.snapshotEvents,
    builder : (context , snapshot) {
        if (snapshot.hasData) {
           final snap =snapshot.data!;
           final progress = snap.bytesTransferred / snap.totalBytes;
           final percentage = (progress *100).toStringAsFixed(2);
          return Text(
            '$percentage %',
            style: const TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
          );

        } else {
          return Container();
        }
    }
  );
  
}
