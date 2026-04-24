import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/ai_service.dart';
import '../services/database_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String language;
  ChatScreen({required this.language});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final AIService _ai = AIService();
  final DatabaseService _db = DatabaseService();
  late String chatId;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    chatId = "chat_${DateTime.now().millisecondsSinceEpoch}";
  }

  void _send() async {
    if (_controller.text.trim().isEmpty) return;
    String userText = _controller.text.trim();
    _controller.clear();

    await _db.saveMessage(
      chatId,
      ChatMessage(sender: "user", message: userText, timestamp: DateTime.now()),
    );

    setState(() => isTyping = true); // AI is thinking...

    String aiReply = await _ai.getAIResponse(userText, widget.language);

    await _db.saveMessage(
      chatId,
      ChatMessage(sender: "ai", message: aiReply, timestamp: DateTime.now()),
    );

    setState(() => isTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.language} Tutor", style: TextStyle(fontSize: 18)),
            Text(
              "Online",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _db.getMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) =>
                      ChatBubble(message: snapshot.data![i]),
                );
              },
            ),
          ),
          if (isTyping)
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tutor is typing...",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
