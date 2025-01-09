import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_flutter/components/chat_bubble.dart';
import 'package:map_flutter/services/chat_service.dart';
import 'package:map_flutter/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // Import for base64Decode

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;

  const ChatPage(
      {super.key, required this.receiverId, required this.receiverEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService chatService = ChatService();
  final UserService userService = UserService();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  String receiverName = '';
  String receiverPhoneNumber = '';
  String? receiverProfileImage; // To hold the profile image

  @override
  void initState() {
    super.initState();
    _fetchReceiverProfile();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchReceiverProfile() async {
    var profile = await userService.getProfile(widget.receiverId);
    setState(() {
      receiverName = profile['username'] ?? 'Unknown';
      receiverPhoneNumber = profile['phone'] ?? '1234567890';
      receiverProfileImage = profile['profileImage']; // Store the profile image
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear();
      // Add a small delay to ensure the new message is rendered
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _callReceiver() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: receiverPhoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _proceedToPayment() {
    Navigator.pushNamed(context, '/payment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            _buildProfileImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.green),
            onPressed: _callReceiver,
          ),
          IconButton(
            icon: const Icon(Icons.payment, color: Colors.blue),
            onPressed: _proceedToPayment,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: _buildMessageInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream:
          chatService.getMessages(widget.receiverId, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          );
        }

        Map<String, List<DocumentSnapshot>> groupedMessages = {};
        for (var doc in snapshot.data!.docs) {
          var messageData = doc.data() as Map<String, dynamic>;
          String dateKey = DateFormat('dd/MM/yyyy')
              .format(messageData['timestamp'].toDate());
          if (!groupedMessages.containsKey(dateKey)) {
            groupedMessages[dateKey] = [];
          }
          groupedMessages[dateKey]!.add(doc);
        }

        // Scroll to bottom when new messages arrive
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: groupedMessages.length,
          itemBuilder: (context, index) {
            String date = groupedMessages.keys.elementAt(index);
            List<DocumentSnapshot> messages = groupedMessages[date]!;

            return Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                ...messages.map((doc) {
                  var messageData = doc.data() as Map<String, dynamic>;
                  bool isCurrentUser =
                      messageData['senderId'] == _auth.currentUser!.uid;
                  String formattedTime = DateFormat('HH:mm')
                      .format(messageData['timestamp'].toDate());

                  return Container(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ChatBubble(
                      message: messageData['message'],
                      color: isCurrentUser ? Colors.green : Colors.blue,
                      isCurrentUser: isCurrentUser,
                      time: formattedTime,
                    ),
                  );
                }).toList(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProfileImage() {
    if (receiverProfileImage != null) {
      // Decode the profile image if it exists
      final imageBytes = base64Decode(receiverProfileImage!);
      return CircleAvatar(
        backgroundImage:
            MemoryImage(imageBytes), // Use MemoryImage for base64 decoded image
      );
    } else {
      // Fallback to showing the first letter of the receiver's name
      return CircleAvatar(
        child:
            Text(receiverName.isNotEmpty ? receiverName[0].toUpperCase() : '?'),
      );
    }
  }
}
