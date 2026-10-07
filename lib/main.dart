import 'package:flutter/material.dart';

void main() {
  runApp(const AlayanSS2App());
}

class User {
  final String username;
  final String password;
  final String status;

  User({required this.username, required this.password, required this.status});
}

class ChatMessage {
  final String sender;
  final String text;
  final String time;

  ChatMessage({required this.sender, required this.text, required this.time});
}

class AlayanSS2App extends StatelessWidget {
  const AlayanSS2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alayan SS2 Members Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF00A884),
        scaffoldBackgroundColor: const Color(0xFF111B21),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00A884),
          secondary: Color(0xFF005C4B),
          surface: Color(0xFF202C33),
          onSurface: Color(0xFFE9EDEF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202C33),
          foregroundColor: Color(0xFFE9EDEF),
          elevation: 0,
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

// In-Memory Database Simulation
class AppDatabase {
  static final List<User> users = [
    User(username: 'admin', password: '123', status: 'Available'),
    User(username: 'john', password: '123', status: 'At SS2 Meetup'),
  ];

  static User? currentUser;

  static final List<ChatMessage> globalMessages = [
    ChatMessage(sender: 'admin', text: 'Welcome to Alayan SS2 Members Group!', time: '10:00 AM'),
    ChatMessage(sender: 'john', text: 'Glad to be here! Hello everyone.', time: '10:05 AM'),
  ];
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = '';

  void _authenticate() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Please fill all fields');
      return;
    }

    if (isLogin) {
      try {
        User found = AppDatabase.users.firstWhere(
          (u) => u.username == username && u.password == password,
        );
        AppDatabase.currentUser = found;
        _navigateToHome();
      } catch (e) {
        setState(() => errorMessage = 'Invalid username or password');
      }
    } else {
      bool exists = AppDatabase.users.any((u) => u.username == username);
      if (exists) {
        setState(() => errorMessage = 'Username already exists');
      } else {
        User newUser = User(username: username, password: password, status: 'Hey there! I am using Alayan SS2');
        AppDatabase.users.add(newUser);
        AppDatabase.currentUser = newUser;
        _navigateToHome();
      }
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Sign In - Alayan SS2' : 'Register - Alayan SS2'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 80,
                  color: Color(0xFF00A884),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alayan SS2 Members Group',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: const Color(0xFF202C33),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: const Color(0xFF202C33),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A884),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _authenticate,
                    child: Text(isLogin ? 'Login' : 'Register', style: const TextStyle(fontSize: 16)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                      errorMessage = '';
                    });
                  },
                  child: Text(
                    isLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login',
                    style: const TextStyle(color: Color(0xFF00A884)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatsListScreen(),
    const GroupChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF202C33),
        selectedItemColor: const Color(0xFF00A884),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'SS2 Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otherUsers = AppDatabase.users
        .where((u) => u.username != AppDatabase.currentUser?.username)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alayan SS2 Chats'),
      ),
      body: ListView.builder(
        itemCount: otherUsers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF005C4B),
                child: Icon(Icons.group, color: Colors.white),
              ),
              title: const Text('Alayan SS2 Global Group', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Tap to join group conversation'),
              trailing: const Text('Live', style: TextStyle(color: Color(0xFF00A884))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupChatScreen(isSubRoute: true)),
                );
              },
            );
          }
          final user = otherUsers[index - 1];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF202C33),
              child: Text(user.username[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user.status),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivateChatScreen(peer: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Global In-Memory Map for Private Chats: Keyed by sorted usernames combination
class PrivateChatDatabase {
  static final Map<String, List<ChatMessage>> chats = {};

  static String getConversationKey(String u1, String u2) {
    List<String> sorted = [u1, u2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }
}

class PrivateChatScreen extends StatefulWidget {
  final User peer;
  const PrivateChatScreen({super.key, required this.peer});

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late String convKey;

  @override
  void initState() {
    super.initState();
    convKey = PrivateChatDatabase.getConversationKey(
      AppDatabase.currentUser!.username,
      widget.peer.username,
    );
    PrivateChatDatabase.chats.putIfAbsent(convKey, () => []);
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      PrivateChatDatabase.chats[convKey]!.add(
        ChatMessage(
          sender: AppDatabase.currentUser!.username,
          text: _controller.text.trim(),
          time: TimeOfDay.now().format(context),
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = PrivateChatDatabase.chats[convKey]!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF005C4B),
              child: Text(widget.peer.username[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Text(widget.peer.username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                bool isMe = msg.sender == AppDatabase.currentUser!.username;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.text, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          msg.time,
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF202C33),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a private message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF00A884)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GroupChatScreen extends StatefulWidget {
  final bool isSubRoute;
  const GroupChatScreen({super.key, this.isSubRoute = false});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendGroupMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      AppDatabase.globalMessages.add(
        ChatMessage(
          sender: AppDatabase.currentUser!.username,
          text: _controller.text.trim(),
          time: TimeOfDay.now().format(context),
        ),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: AppDatabase.globalMessages.length,
            itemBuilder: (context, index) {
              final msg = AppDatabase.globalMessages[index];
              bool isMe = msg.sender == AppDatabase.currentUser!.username;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF005C4B) : const Color(0xFF202C33),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Text(
                          msg.sender,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00A884),
                          ),
                        ),
                      Text(msg.text, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 2),
                      Text(
                        msg.time,
                        style: const TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF202C33),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Message Alayan SS2 Group...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFF00A884)),
                onPressed: _sendGroupMessage,
              ),
            ],
          ),
        ),
      ],
    );

    if (widget.isSubRoute) {
      return Scaffold(
        appBar: AppBar(title: const Text('Alayan SS2 Global Group')),
        body: content,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Alayan SS2 Global Group'), automaticallyImplyLeading: false),
      body: content,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController(text: AppDatabase.currentUser?.status ?? '');
  }

  void _updateStatus() {
    setState(() {
      // Create a new updated user since fields are final
      int index = AppDatabase.users.indexWhere((u) => u.username == AppDatabase.currentUser!.username);
      if (index != -1) {
        User updated = User(
          username: AppDatabase.currentUser!.username,
          password: AppDatabase.currentUser!.password,
          status: _statusController.text.trim(),
        );
        AppDatabase.users[index] = updated;
        AppDatabase.currentUser = updated;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Status updated successfully')),
    );
  }

  void _logout() {
    AppDatabase.currentUser = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppDatabase.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF005C4B),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              user?.username ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _statusController,
              decoration: const InputDecoration(
                labelText: 'About / Status',
                filled: true,
                fillColor: Color(0xFF202C33),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C4B),
                  foregroundColor: Colors.white,
                ),
                onPressed: _updateStatus,
                child: const Text('Update Status'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[800],
                  foregroundColor: Colors.white,
                ),
                onPressed: _logout,
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}