import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    DateTime dateTime = (snapshot['DATE'] as Timestamp).toDate();
    date = DateFormat('yyyy-MM-dd HH:mm')
        .format(dateTime); // Format the date without seconds
    uidUser = map["AUTRE_UID"];
    idConversation = map["ID_CONVERSATION"];
  }
}
