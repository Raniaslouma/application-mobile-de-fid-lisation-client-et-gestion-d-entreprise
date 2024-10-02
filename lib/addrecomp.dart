import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listrecmps.dart';
import 'package:intl/intl.dart';
class RecompenseEntrep extends StatefulWidget {
  const RecompenseEntrep({super.key});

  @override
  State<RecompenseEntrep> createState() => _RecompenseEntrepState();
}

class _RecompenseEntrepState extends State<RecompenseEntrep> {
  final _formKey = GlobalKey<FormState>();
   String prix = '' ;
  String name = '';

  final offercontroller = TextEditingController();
  final conditioncontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  static final ptsaccumController = TextEditingController();
  static final prixController = TextEditingController();
static final nameproductController = TextEditingController();
static final nbrproductController = TextEditingController();
  
  DateTime? dateDebut = DateFormat("yyyy-MM-dd").parse("2023-05-01");
DateTime? dateFin = DateFormat("yyyy-MM-dd").parse("2023-05-06");

CollectionReference recompref =FirebaseFirestore.instance.collection('Recompense');
  Future<void> addRecomp() {
    return recompref
        .add({
          'offre': offercontroller.text,
          'type': _selectedOption,
          'dateDebut':dateDebut,
          'dateFin':dateFin,

          'points accumulés':ptsaccumController.text,
          "prix d'achat":prixController.text,
          "nom produit":nameproductController.text,
          "nombre des produit":nbrproductController.text,
          "Description":descriptioncontroller.text,
          
          
        })
        .then((value) => print("recompense Added"))
        .catchError((error) => print("Failed to add recomp: $error"));
  }
  var _selectedDate = DateTime.now();

//validator barcode

  List<String> _optionsList = [
    "Points accumulés",
    "Montant d'achat",
    "Nombre des produits"
  ];
  


// Valeur sélectionnée par défaut

// Formulaire pour l'option 1

  Widget _PointsaccumulesForm = Container(
    child: TextFormField(
      controller: ptsaccumController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 3),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'Nombre des points',
        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Champ obligatoire vide !';
        }
        final n = int.tryParse(value);
        if (n == null || n <= 0) {
          return 'Veuillez entrer un nombre valide supérieur à zéro.';
        }
        return null;
      },
    ),
  );

// Formulaire pour l'option 2
  Widget _MontantachatForm = Container(
    child: TextFormField(
      controller:prixController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 3),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: 'Prix achat',
        suffixText: ' DT',
        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Champ obligatoire vide !';
        }  if (int.tryParse(value) == null) {
    return 'Le champ doit être un nombre';
  }
        return null;
      },
      /*  onSaved: (value) {
      prix = value!; 
    }, */
    ),
  );

// Formulaire pour l'option 3
  Widget _NomberdesproduitsForm = Container(
    child: Column(children: [
      
      TextFormField(
        controller:nameproductController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Nom produit',
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Champ obligatoire vide !';
          }
          return null;
        },
       /*  onSaved: (value) {
      name = value; 
    }, */
    keyboardType: TextInputType.text,
      ),
      SizedBox(
        height: 25,
      ),
      TextFormField(
        controller:nbrproductController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Nombre des produits achetés',
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Champ obligatoire vide !';
          }
          final n = int.tryParse(value);
          if (n == null || n <= 0) {
            return 'Veuillez entrer un nombre valide supérieur à zéro.';
          }
          return null;
        },
      ),
    ]),
  );

// Méthode onChanged pour le menu déroulant
  void _onOptionChanged(String value) {
    setState(() {
      _selectedOption = value;
    });
  }

  late String _selectedOption;
// Méthode pour afficher le formulaire correspondant à l'option sélectionnée
  Widget _getSelectedOptionForm() {
    switch (_selectedOption) {
      case "Points accumulés":
        return _PointsaccumulesForm;
      case "Montant d'achat":
        return _MontantachatForm;
      case "Nombre des produits":
        return _NomberdesproduitsForm;
      default:
        return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedOption = _optionsList[0];
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 31, 81, 248),
            title: const Text(
          "Ajouter récompense",
          textAlign: TextAlign.center,
        )),
        body: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Form(
                key: _formKey,
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(children: [
                     
                      Padding(padding: EdgeInsets.symmetric(vertical: 15)),

                      DropdownButtonFormField(
                        value: _selectedOption,
                        items: _optionsList
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value as String;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Type de récompense",
                            hintStyle: TextStyle(color: Colors.black),),
                            
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Champ obligatoire vide !';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          conditioncontroller.text = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      _getSelectedOptionForm(),
                      SizedBox( height: 25,),
                      TextFormField(
                        controller: offercontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Cadeau offert",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Champ obligatoire vide !';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          offercontroller.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.event_note),
                          labelText: "Date debut",
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        onDateSelected: (DateTime value) {
                         setState(() {
                  dateDebut = value;
                });
                        },
                        validator: (DateTime? dateTime) {
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
                      SizedBox(
                        height: 25,
                      ),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: "Date fin",
                        ),
                        mode: DateTimeFieldPickerMode.date,
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
             if (dateTime == 'existing_value') {
        return 'il existe un catalogue qui finit dans ce date !';
      }
            return null;
          },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: descriptioncontroller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Description",
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
                      ),
                      SizedBox(
                        height: 60,
                      ),
                     
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const listrecomp();
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
                             addRecomp();
              print("created succefuly");
               Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const listrecomp()),);
      showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: const Text('Succès'),
      content: const Text('La recompense a été ajouté avec succès'),
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
                      SizedBox(
                        height: 25,
                      )
                    ])))));
  }
}