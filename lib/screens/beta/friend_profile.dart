import 'package:flutter/material.dart';
import 'package:pingme/screens/beta/chat_screen.dart';
import 'package:pingme/services/create_or_find_chat.dart';
import 'package:pingme/services/dto/user_info_dto.dart';

class FriendProfile extends StatefulWidget {
  final UserInfoDTO user;

  const FriendProfile({super.key, required this.user});

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  bool isFollowing = false; // State variable to track follow status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Avatar Section
            ProfilePic(
              image: widget.user.avatar ??
                  'https://i.pinimg.com/736x/5a/49/4f/5a494fbc7ee62a576d68d96559c38741.jpg',
            ),
            // Display Name
            Text(
              widget.user.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 16.0 * 2),
            // Info Section
            Info(infoKey: "User ID", info: widget.user.username),
            Info(infoKey: "Email Address", info: widget.user.email),
            const SizedBox(height: 16.0),
            // Actions Section
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Align buttons in the center
              children: [
                // Follow Button
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      setState(() {
                        isFollowing = !isFollowing; // Toggle follow state
                      });
                    },
                    child: Text(isFollowing
                        ? "Followed"
                        : "Follow"), // Toggle button text
                  ),
                ),
                const SizedBox(width: 16), // Space between the buttons
                // Message Button
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        // Call API to create or find chat object
                        final chatService = CreateOrFindChat();
                        final chat =
                            await chatService.createOrFindChat(widget.user.id);

                        // Navigate to ChatScreen with chat data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: widget.user.id,
                              displayName: widget.user.displayName,
                              chat: chat, // Pass chat object to ChatScreen
                            ),
                          ),
                        );
                      } catch (e) {
                        // Show error message if API fails
                        print('Error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to start chat: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Nhắn Tin',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(image),
          ),
          if (isShowPhotoUpload)
            InkWell(
              onTap: imageUploadBtnPress,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

  final String infoKey, info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            infoKey,
            style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.8),
            ),
          ),
          Text(info),
        ],
      ),
    );
  }
}
