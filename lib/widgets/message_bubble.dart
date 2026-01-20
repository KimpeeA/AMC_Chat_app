import 'package:flutter/material.dart';
import '/models/chat_message.dart';

class MessageBubble extends StatelessWidget{

  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUserMessage
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUserMessage
              ? Colors.blue[100]
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(message.text, style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
