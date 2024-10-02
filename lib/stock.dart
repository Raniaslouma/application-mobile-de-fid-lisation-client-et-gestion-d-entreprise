
/*  isAffiche ? 
        
        /*desgin ll affichage*/
         Container( color: Colors.white,
                
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: FutureBuilder(
            future: catalogueCollection.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Map<String, dynamic>> list = [];
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
                          title: Text("titre: ${list[i]['titre'].toString()}",
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "titre: ${list[i]["titre"]}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),),
                              Text(
                                  "Description: ${list[i]["Description"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  "date debut: ${list[i]["date debut"]}",
                                   style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  "date Fin: ${list[i]["dateFin"]}",
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
/*                                 IconButton(
                                  onPressed: () async {
                                    catalogueCollection
                                        .doc(snapshot.data!.docs[i].id)
                                        .delete();
                                    setState(() {
                                      catalogueCollection.get();
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
                                ), */
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
            }),) */