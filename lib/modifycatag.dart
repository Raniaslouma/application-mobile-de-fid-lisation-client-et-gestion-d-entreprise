import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import 'button_widget.dart';
import 'listcatag.dart';
import 'uploadcatalogue.dart';

class modifycatalogue extends StatefulWidget {
  final String docsid;
  final BD;
  const modifycatalogue ({Key? key,  required this.docsid, required this.BD}) : super(key: key);

  @override
  State<modifycatalogue> createState() => _modifycatalogueState();
}

class _modifycatalogueState extends State<modifycatalogue> {
  
final _formKey = GlobalKey<FormState>();
final titreController = TextEditingController();
final descriptionController = TextEditingController();
DateTime? dateDebut = DateFormat("yyyy-MM-dd").parse("2023-05-01");
DateTime? dateFin = DateFormat("yyyy-MM-dd").parse("2023-05-06");
  PlatformFile? pickedFile;
  UploadTask? task;
  File? file;
  String? titre, Description;
  DateTime? datedebut,datefin;
 //XFile? image;
 List<File> imageFiles = [];
List<String> imageUrls = [];
CollectionReference catalogueCollection = FirebaseFirestore.instance.collection('catalogue');
Future updateCatalogue()async{
     try {
                                    await catalogueCollection.doc(widget.docsid).update({
                                     "titre": titre,
                                     "Description": Description,
                                     "date debut": datedebut,
                                     "dateFin":datefin,
                                    // "fichier":image,
                                    });
                                         
                                    } catch (e) {
                                      debugPrint("Error $e");
                                    }
  }
    

      @override
      
    Widget build(BuildContext context) {
      final String fileName;
      if (file !=null) {
        fileName = basename(file!.path);
      } else {
        fileName = 'Pas de Fichier';
      }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 31, 81, 248),
            title: const Text(" Modification du catalogue",
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
                     initialValue: widget.BD["titre"] == null? "" : widget.BD["titre"].toString(),
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
                      titre = value!;
                    },
                  ),
                   const SizedBox(height: 35),

                  TextFormField(
                    initialValue: widget.BD["Description"] == null? "" : widget.BD["Description"].toString(),
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
                      Description = value!;
                    },
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    autofocus: true,
                  ),
                 const SizedBox(height: 35),
                 DateTimeFormField(
                    initialValue: widget.BD["date debut"] == null ? null : widget.BD["date debut"].toDate(),
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
                     validator: (DateTime ?dateTime) {
            if (dateTime == null) {
              return 'Veuillez sélectionner une date.';
            }
            return null;
          } ,
           onSaved: (value) {
                        datedebut = value;
                      },  ),
const SizedBox(height: 35),
                 DateTimeFormField(
                    initialValue: widget.BD["dateFin"] == null ? null : widget.BD["dateFin"].toDate(),
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
                     validator: (DateTime ?dateTime) {
            if (dateTime == null) {
              return 'Veuillez sélectionner une date.';
            }
            if (dateDebut!.isAfter(dateFin!)) {
              return 'La date fin doit être ultérieure à la date debut';
            }
            return null;
          },
                     onSaved: (value) {
                        datefin = value;
                      },
                      ),

                 const SizedBox(height: 60),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const Catalogue();
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
                             updateCatalogue();
              print("updated succefuly");
               Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const addcatalogue()),);
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: const Text('Le catalogue a été modifié avec succès'),
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
