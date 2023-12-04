import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chat_id;
  final String user;
  final int number_att;
  final Timestamp last;

  Chat(
      {required this.chat_id,
      required this.user,
      required this.number_att,
      required this.last});
}
