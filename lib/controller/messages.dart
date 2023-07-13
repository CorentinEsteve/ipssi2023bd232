import 'package:ipssi_bd23_2/model/utilisateur.dart';
import 'package:ipssi_bd23_2/model/message.dart';
import 'package:flutter/material.dart';
import 'package:ipssi_bd23_2/view/background_view.dart';
import 'constante.dart';
import 'firestoreHelper.dart';

class MessagerieView extends StatefulWidget {
  Utilisateur autrePersonne;
  MessagerieView({Key? key, required this.autrePersonne}) : super(key: key);

  @override
  State<MessagerieView> createState() => _MessagerieViewState();
}

class _MessagerieViewState extends State<MessagerieView> {
  //variable
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.autrePersonne.fullName),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          BackgroundView(),
          bodyPage(),
        ],
      ),
    );
  }

  Widget bodyPage() {
    return SafeArea(
      bottom: true,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<List<Message>>(
                  stream: FirestoreHelper()
                      .getMessage(widget.autrePersonne.uid, moi.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.runtimeType);
                      print(snapshot);
                      return const Center(
                        child: Text("Erreur de connexion"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Text("attente de co"),
                      );
                    }
                    List<Message> messages = snapshot.data ?? [];
                    print(messages.length);
                    print(messages.runtimeType);
                    print(snapshot.data);
                    print(snapshot.runtimeType);
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message = messages[index];
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: message.uidUser == moi.uid
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: message.uidUser == moi.uid
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(message.message),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      message.date,
                                      style: const TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
            const Divider(
              height: 1.5,
            ),
            //message qu'on  tape
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration.collapsed(
                          hintText: "Entrer votre message"),
                      maxLines: null,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        if (messageController.text != "") {
                          String message = messageController.text;
                          FirestoreHelper().sendMessage(
                              moi.uid, widget.autrePersonne.uid, message);
                          setState(() {
                            messageController.text = "";
                          });
                        }
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
