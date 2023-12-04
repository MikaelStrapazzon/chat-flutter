import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/appBars/DefaultAppBar/default_app_bar.dart';

class ChatScreenPage extends StatefulWidget {
  final String idChat;
  final String userId;
  final String keyChatList;

  const ChatScreenPage(
      {super.key,
      required this.idChat,
      required this.userId,
      required this.keyChatList});

  static String id = '/ChatScreenPage';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreenPage> {
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

    if (messageText.isEmpty) {
      return;
    }

    await _firestore.collection(widget.idChat).add({
      'text': messageText,
      'senderId': _user!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore
        .collection('chats:${widget.userId}')
        .doc(widget.keyChatList)
        .update(
            {'number_att': FieldValue.increment(1), 'last': Timestamp.now()});

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          DefaultAppBar(title: 'Chats:${widget.idChat}', showBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection(widget.idChat)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  var messageText = message['text'];
                  var senderId = message['senderId'];

                  var messageWidget = MessageWidget(
                    messageText: messageText,
                    isMe: _user?.uid == senderId,
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  reverse: true,
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String messageText;
  final bool isMe;

  const MessageWidget(
      {super.key, required this.messageText, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 10 : 0),
              bottomLeft: Radius.circular(isMe ? 10 : 0),
              topRight: Radius.circular(isMe ? 0 : 10),
              bottomRight: Radius.circular(isMe ? 0 : 10),
            ),
          ),
          child: Text(
            messageText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
