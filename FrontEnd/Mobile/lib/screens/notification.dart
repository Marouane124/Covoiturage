import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String timeAgo,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFE2F5ED) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF121212),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            timeAgo,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Today',
              style: TextStyle(
                color: Color(0xFF121212),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
          _buildNotificationItem(
            title: 'Payment confirm',
            description: 'Lorem ipsum dolor sit amet consectetur. Ultrici est tincidunt eleifend vitae',
            timeAgo: '15 min ago',
            isHighlighted: true,
          ),
          _buildNotificationItem(
            title: 'Payment confirm',
            description: 'Lorem ipsum dolor sit amet consectetur. Ultrici est tincidunt eleifend vitae',
            timeAgo: '2h ago',
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              'Yesterday',
              style: TextStyle(
                color: Color(0xFF121212),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
          _buildNotificationItem(
            title: 'Payment confirm',
            description: 'Lorem ipsum dolor sit amet consectetur. Ultrici est tincidunt eleifend vitae',
            timeAgo: '15 min ago',
            isHighlighted: true,
          ),
          _buildNotificationItem(
            title: 'Payment confirm',
            description: 'Lorem ipsum dolor sit amet consectetur. Ultrici est tincidunt eleifend vitae',
            timeAgo: '25 min ago',
          ),
          _buildNotificationItem(
            title: 'Payment confirm',
            description: 'Lorem ipsum dolor sit amet consectetur. Ultrici est tincidunt eleifend vitae',
            timeAgo: '30 min ago',
          ),
          _buildNotificationItem(
            title: 'Payment confirm',
            description: 'Lorem ipsum dolor sit amet consectetur. Ultrici est tincidunt eleifend vitae',
            timeAgo: '15 min ago',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }
}
