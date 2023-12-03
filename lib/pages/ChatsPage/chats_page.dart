import 'package:chat_flutter/components/appBars/DefaultAppBar/default_app_bar.dart';
import 'package:chat_flutter/pages/ChatsPage/ChatListItems/chat_list_items.dart';
import 'package:chat_flutter/types/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  static String id = '/ChatsPage';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

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

  void _sendMessage() async {
    String messageText = _messageController.text.trim();

    if (messageText.isNotEmpty) {
      await _firestore.collection('messages').add({
        'text': messageText,
        'senderId': _user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Chats List'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('chats:${_user!.uid}').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: Text(
                    "You haven't started any Xet yet. How about starting a Xet with a friend?"));
          }

          var chats = snapshot.data!.docs.reversed;
          List<Widget> chatsWidget = [];

          for (var chat in chats) {
            chatsWidget.add(ChatListItems(
              item: Chat(
                  collection_id: chat['collection_id'], user: chat['user']),
              onTap: () => {},
            ));
          }

          return ListView(children: chatsWidget);
        },
      ),
    );
  }
}
