import 'package:chat_flutter/components/appBars/DefaultAppBar/default_app_bar.dart';
import 'package:chat_flutter/pages/ChatsPage/ChatListItems/chat_list_items.dart';
import 'package:chat_flutter/pages/QrCodePage/qrcode_page.dart';
import 'package:chat_flutter/types/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../components/buttons/ActionButton/action_button.dart';
import '../../components/floatingActionButtons/ExpandableFAB/expandable_fab.dart';
import '../ChatScreenPage/chat_screen_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  static String id = '/ChatsPage';

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
        await _firestore.collection('chats:${_user?.uid}').add({
          'collection_id': _user!.uid + code,
          'user': code,
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
      appBar: const DefaultAppBar(title: 'Chats List'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('chats:${_user?.uid}').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: Text(
                    "You haven't started any Xet yet. How about starting a Xet with a friend?"));
          }

          var chats = snapshot.data?.docs.reversed;
          List<Widget> chatsWidget = [];

          for (var chat in chats!) {
            chatsWidget.add(ChatListItems(
              item: Chat(
                  collection_id: chat['collection_id'], user: chat['user']),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChatScreenPage(idChat: chat['collection_id']),
                  ),
                )
              },
            ));
          }

          return ListView(children: chatsWidget);
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 80,
        children: [
          ActionButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrCodePage(idUser: _user!.uid),
                ),
              )
            },
          ),
          ActionButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: escaneiaQRCode,
          ),
        ],
      ),
    );
  }
}
