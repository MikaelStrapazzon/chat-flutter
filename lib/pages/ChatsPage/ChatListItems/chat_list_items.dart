import 'package:chat_flutter/types/chat.dart';
import 'package:flutter/material.dart';

class ChatListItems extends StatelessWidget {
  final Chat item;
  final VoidCallback onTap;

  const ChatListItems({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 36),
            leading: const Icon(Icons.chat), // Ícone à esquerda
            title: Text(item.chat_id), // Texto no centro
            trailing: item.number_att > 0
                ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      item.number_att.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : null));
  }
}
