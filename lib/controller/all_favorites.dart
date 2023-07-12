import 'package:flutter/material.dart';
import 'package:ipssi_bd23_2/controller/constante.dart';
import 'package:ipssi_bd23_2/controller/firestoreHelper.dart';
import 'package:ipssi_bd23_2/model/utilisateur.dart';
import 'package:ipssi_bd23_2/controller/messages.dart';

class AllFavorites extends StatefulWidget {
  const AllFavorites({Key? key}) : super(key: key);

  @override
  State<AllFavorites> createState() => _AllFavoritesState();
}

class _AllFavoritesState extends State<AllFavorites> {
  List<Utilisateur> users = [];
  List mesFavoris = [];

  @override
  void initState() {
    for (int i = 0; i < moi.favoris!.length; i++) {
      FirestoreHelper().getUser(moi.favoris![i]).then((value) {
        setState(() {
          mesFavoris.add(value);
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mesFavoris.length,
      itemBuilder: (context, index) {
        Utilisateur user = mesFavoris[index];
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(user.avatar ?? defaultImage),
                        ),
                        SizedBox(height: 16),
                        Text(
                          user.fullName ?? "Nom",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(user.email),
                        Text(
                          user.telephone ?? "Téléphone",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.avatar ?? defaultImage),
              ),
              title: Text(user.fullName ?? "Nom"),
              subtitle: Text(user.email, textAlign: TextAlign.start),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessagerieView(autrePersonne: user)));
                },
                icon: const Icon(
                  Icons.message_outlined,
                  color: Color.fromARGB(255, 95, 127, 255),
                  size: 25,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
