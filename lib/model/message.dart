import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ipssi_bd23_2/controller/constante.dart';

//fait le model de Message
class Message {
  late String uid;
  late String message;
  late String date;
  late String uidUser;
  late String idConversation;

  Message(DocumentSnapshot snapshot) {
    uid = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    message = map["MESSAGE"];
    date = map["DATE"];
    uidUser = map["AUTRE_UID"];
    idConversation = map["ID_CONVERSATION"];
  }

}