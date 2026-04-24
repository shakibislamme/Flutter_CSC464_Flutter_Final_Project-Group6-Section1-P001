import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message.sender == "user";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(14),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser ? Colors.blueAccent : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: isUser ? Radius.circular(20) : Radius.circular(0),
                bottomRight: isUser ? Radius.circular(0) : Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Text(
              "${message.timestamp.hour}:${message.timestamp.minute}",
              style: TextStyle(fontSize: 10, color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}
