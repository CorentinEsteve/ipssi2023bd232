import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ipssi_bd23_2/controller/constante.dart';
import 'package:ipssi_bd23_2/controller/firestoreHelper.dart';
import 'package:ipssi_bd23_2/model/utilisateur.dart';

class AllPerson extends StatefulWidget {
  const AllPerson({Key? key}) : super(key: key);

  @override
  State<AllPerson> createState() => _AllPersonState();
}

class _AllPersonState extends State<AllPerson> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreHelper().cloudUsers.snapshots(),
        builder: (context, snap) {
          List? documents = snap.data?.docs;
          if (documents == []) {
            return const Text("Aucune DonnÃ©e");
          } else {
            return ListView.builder(
                itemCount: documents!.length,
                itemBuilder: (context, index) {
                  Utilisateur lesAutres = Utilisateur(documents[index]);
                  return Card(
                    elevation: 10,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(lesAutres.avatar ?? defaultImage),
                      ),
                      title: Text(lesAutres.fullName),
                      subtitle: Text(
                        lesAutres.email,
                        textAlign: TextAlign.start,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          moi.favoris!.contains(lesAutres.uid)
                              ? moi.favoris!.remove(lesAutres.uid)
                              : moi.favoris!.add(lesAutres.uid);
                          FirestoreHelper()
                              .updateUser(moi.uid, {"FAVORIS": moi.favoris});
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: moi.favoris!.contains(lesAutres.uid)
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }
}
