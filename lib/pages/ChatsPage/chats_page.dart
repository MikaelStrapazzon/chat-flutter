import 'package:chat_flutter/components/appBars/DefaultAppBar/default_app_bar.dart';
import 'package:chat_flutter/pages/ChatsPage/ChatListItems/chat_list_items.dart';
import 'package:chat_flutter/pages/QrCodePage/qrcode_page.dart';
import 'package:chat_flutter/types/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../../components/buttons/ActionButton/action_button.dart';
import '../../components/floatingActionButtons/ExpandableFAB/expandable_fab.dart';
import '../ChatScreenPage/chat_screen_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  escaneiaQRCode() async {
    try {
      String code = await FlutterBarcodeScanner.scanBarcode(
          "#FFFF0000", "Cancelar", false, ScanMode.QR);

      if (code != "-1") {
        await _firestore
            .collection('chats:${_user?.uid}')
            .doc(_user!.uid + code)
            .set({
          'chat_id': _user!.uid + code,
          'user': code,
          'number_att': 0,
          'last': Timestamp.now()
        });

        await _firestore.collection('chats:$code').doc(_user!.uid + code).set({
          'chat_id': _user!.uid + code,
          'user': _user!.uid,
          'number_att': 0,
          'last': Timestamp.now()
        });

        return;
      }
    } catch (e) {}

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Não foi possível escanear o código QR.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Xets List'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chats:${_user?.uid}')
            .orderBy('last')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var chats = snapshot.data?.docs.reversed;
          List<Widget> chatsWidget = [];

          for (var chat in chats!) {
            chatsWidget.add(ChatListItems(
                item: Chat(
                    chat_id: chat['chat_id'],
                    user: chat['user'],
                    number_att: chat['number_att'],
                    last: chat['last']),
                onTap: () => Get.to(
                      () => ChatScreenPage(
                          idChat: chat['chat_id'],
                          userId: chat['user'],
                          myId: _user!.uid,
                          keyChatList: chat.id),
                    )));
          }

          return ListView(children: chatsWidget);
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 80,
        children: [
          ActionButton(
              icon: const Icon(Icons.qr_code),
              onPressed: () => Get.to(() => QrCodePage(idUser: _user!.uid))),
          ActionButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: escaneiaQRCode,
          ),
        ],
      ),
    );
  }
}
