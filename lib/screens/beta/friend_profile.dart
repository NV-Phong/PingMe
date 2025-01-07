import 'package:flutter/material.dart';
import 'package:pingme/screens/beta/chat_screen.dart';
import 'package:pingme/services/create_or_find_chat.dart';
import 'package:pingme/services/dto/user_info_dto.dart';

class FriendProfile extends StatelessWidget {
  final UserInfoDTO user;
  final CreateOrFindChat chatService = CreateOrFindChat();

  FriendProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.displayName),
        centerTitle: true,
        backgroundColor: Colors.purple, // Adjusted color for a modern feel
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Cover Image Section
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    user.cover ??
                        'https://i.pinimg.com/736x/ea/ef/f7/eaeff7bf857d101db304c3df97f32dda.jpg', // Default cover image
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Avatar Section
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                user.avatar ??
                    'https://i.pinimg.com/736x/5a/49/4f/5a494fbc7ee62a576d68d96559c38741.jpg', // Default avatar image
              ),
            ),
            const SizedBox(height: 16),
            // Display Name
            Text(
              user.displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Username
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            // Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   'ID: ${user.id}',
                    //   style: const TextStyle(fontSize: 16),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Actions
            ElevatedButton(
              onPressed: () {
                // Add Friend functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add Friend'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                chatService.createOrFindChat(user.id);
                // Navigate to ChatScreen with user.id and user.displayName
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userId: user.id, // Pass user.id
                      displayName: user.displayName, // Pass displayName
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Message'),
            ),
          ],
        ),
      ),
    );
  }
}
