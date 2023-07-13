//elle va effectué toutes les opérations concernant la base de donnée
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipssi_bd23_2/model/utilisateur.dart';

import '../model/message.dart';

class FirestoreHelper {
  //attributs
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final cloudUsers = FirebaseFirestore.instance.collection("UTILISATEURS");
  final cloudMessages = FirebaseFirestore.instance.collection("MESSAGES");

  //méthode
  //inscription
  Future<Utilisateur> register(
      String nom, String prenom, String email, String password) async {
    UserCredential resultat = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    String uid = resultat.user!.uid;
    Map<String, dynamic> map = {
      "NOM": nom,
      "PRENOM": prenom,
      "EMAIL": email,
    };
    addUser(uid, map);
    return getUser(uid);
  }

  //connexion
  Future<Utilisateur> connect(String email, String password) async {
    UserCredential resultat =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return getUser(resultat.user!.uid);
  }

  //récuperer mon utilisateur
  Future<Utilisateur> getUser(String uid) async {
    DocumentSnapshot snapshot = await cloudUsers.doc(uid).get();
    return Utilisateur(snapshot);
  }

  //ajouter un utilisateur
  addUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).set(map);
  }

  updateUser(String uid, Map<String, dynamic> map) {
    cloudUsers.doc(uid).update(map);
  }

  //mise à jour des infos de l'utilisateur

  //stocker les images
  Future<String> stockageImage(
      String dossier, String nameImage, String uid, Uint8List datas) async {
    TaskSnapshot snapshot =
        await storage.ref("/$dossier/$uid/$nameImage").putData(datas);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  //envoyer un message entre deux utilisateurs avec un id qui es
  sendMessage(String uid, String autreUid, String message) {
    String idConversation =
        (uid.compareTo(autreUid) < 0) ? "$uid-$autreUid" : "$autreUid-$uid";
    Map<String, dynamic> map = {
      "MESSAGE": message,
      "DATE": DateTime.now(),
      "UID": uid,
      "AUTRE_UID": autreUid,
      "ID_CONVERSATION": idConversation,
    };
    cloudMessages.add(map);
  }

  //fait un getter pour les messages entre deux utilisateurs
  getMessage(String uid, String autreUid) {
    String idConversation =
        (uid.compareTo(autreUid) < 0) ? "$uid-$autreUid" : "$autreUid-$uid";
    return cloudMessages
        .where("ID_CONVERSATION", isEqualTo: idConversation)
        .orderBy("DATE", descending: true)
        .snapshots()
        .map((event) => event.docs.map((e) => Message(e)).toList());
  }
}
