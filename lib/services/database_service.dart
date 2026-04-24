import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveMessage(String chatId, ChatMessage msg) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(msg.toMap());
  }

  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromFirestore(doc.data()))
              .toList(),
        );
  }
}
