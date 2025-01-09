import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_flutter/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to fetch all chat rooms
  Stream<QuerySnapshot> fetchAllChatRooms() {
    return _firestore.collection('chatrooms').snapshots();
  }

  // Method to fetch a specific chat room by ID
  Future<DocumentSnapshot?> fetchChatRoomById(String chatRoomId) async {
    print(
        "Fetching chat room with ID: $chatRoomId"); // Log the ID being fetched
    try {
      DocumentSnapshot doc =
          await _firestore.collection('chatrooms').doc(chatRoomId).get();
      return doc.exists ? doc : null; // Return the document if it exists
    } catch (e) {
      print("Error fetching chat room: $e");
      return null; // Return null in case of an error
    }
  }

  // Method to send a message
  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!.toString();
    final Timestamp timestamp = Timestamp.now();

    // Create the message object
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    // Construct the chat room ID
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Save the message
    await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    // Update chatroom metadata
    await _firestore.collection('chatrooms').doc(chatRoomId).set({
      'participants': ids,
      'lastMessage': message,
      'lastMessageTimestamp': timestamp,
    }, SetOptions(merge: true)); // Use merge to avoid overwriting existing data
  }

  //Récupérer les messages
  Stream<QuerySnapshot> getMessages(String currentUserId, String receiverId) {
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> testFetchChatRoom() async {
    String chatRoomId =
        'iIbvb4SwYmPNXnDcWYdWXIz1O5R2_of8Qcbby0aS7qJ2FEH7OHNjNhoO2'; // Your chat room ID
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .get();
      if (doc.exists) {
        print("Chat Room ID: ${doc.id}");
        // Access other fields if needed
      } else {
        print("Chat room not found.");
      }
    } catch (e) {
      print("Error fetching chat room: $e");
    }
  }

  // Method to fetch messages from a specific chat room
  Stream<QuerySnapshot> fetchMessages(String chatRoomId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Order messages by timestamp
        .snapshots();
  }
}
