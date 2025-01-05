import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_flutter/components/chat_bubble.dart';
import 'package:map_flutter/services/chat_service.dart';
import 'package:map_flutter/services/user_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String receiverName = '';
  String receiverPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchReceiverProfile();
  }

  void _fetchReceiverProfile() async {
    var profile = await userService.getProfile(widget.receiverId);
    setState(() {
      receiverName = profile['username'] ?? 'Unknown';
      receiverPhoneNumber = profile['phone'] ?? '1234567890';
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverId, _messageController.text);
      _messageController.clear();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: Text(receiverName)),
        backgroundColor: Colors.green,
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 10, 118, 219),
            ),
            child: IconButton(
              icon: Icon(Icons.phone, color: Colors.white),
              onPressed: _callReceiver,
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 219, 34, 10)),
            child: IconButton(
              icon: Icon(Icons.payment, color: Colors.white),
              onPressed: _proceedToPayment,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream:
          chatService.getMessages(widget.receiverId, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // Group messages by date
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

        // Build the list of messages
        List<Widget> messageWidgets = [];
        groupedMessages.forEach((date, messages) {
          messageWidgets.add(
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );

          for (var message in messages) {
            var messageData = message.data() as Map<String, dynamic>;
            String formattedTime =
                DateFormat('HH:mm').format(messageData['timestamp'].toDate());

            // Custom alignment logic
            var alignment = messageData['senderId'] == _auth.currentUser!.uid
                ? Alignment.centerRight
                : Alignment.centerLeft;

            messageWidgets.add(
              Container(
                alignment: alignment,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:
                        (messageData['senderId'] == _auth.currentUser!.uid)
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      ChatBubble(message: messageData['message']),
                      Text(formattedTime, style: TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ),
            );
          }
        });

        return ListView(children: messageWidgets);
      },
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 36, 129, 21)),
              ),
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              filled: true,
              hintText: 'Enter message',
              hintStyle:
                  TextStyle(color: const Color.fromARGB(255, 111, 105, 105)),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: Icon(Icons.send, size: 30, color: Colors.green),
        ),
      ],
    );
  }
}
