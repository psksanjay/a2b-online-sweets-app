// HomeScreen with improved UI, preserved navigation, mood-based chatbox, and chatbot sweet suggestions
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sweets/sweet_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _primaryOrange = Color(0xFFFF7F50);
  final Color _lightOrange = Color(0xFFFFF3E0);
  final Color _darkOrange = Color(0xFFE65100);

  final List<Map<String, String>> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Map<String, String> sweetInfo = {
    "Badam Halwa": "Badam Halwa (100g):\n• Calories: ~400kcal\n• Rich in almonds\n• Energy booster",
    "Rasgulla": "Rasgulla (100g):\n• Calories: ~186kcal\n• Made from chenna\n• Light & refreshing",
    "Jangiri": "Jangiri (100g):\n• Calories: ~320kcal\n• Made from urad dal\n• High in sugar",
    "Mysore Pak": "Mysore Pak (100g):\n• Calories: ~450kcal\n• Made with ghee\n• Quick energy",
    "Laddu": "Laddu (100g):\n• Calories: ~350kcal\n• Gram flour & ghee\n• Comfort food",
    "Kaju Katli": "Kaju Katli (100g):\n• Calories: ~430kcal\n• Made with cashews\n• High protein",
    "Milk Cake": "Milk Cake (100g):\n• Calories: ~410kcal\n• Grainy texture\n• Rich in dairy",
    "Soan Papdi": "Soan Papdi (100g):\n• Calories: ~470kcal\n• Flaky sweet\n• Light treat",
    "Gulab Jamun": "Gulab Jamun (100g):\n• Calories: ~330kcal\n• Fried sweet\n• All-time favorite",
    "Kalakand": "Kalakand (100g):\n• Calories: ~320kcal\n• Moist paneer sweet\n• Rich in milk",
    "Mixture": "Mixture (100g):\n• Calories: ~500kcal\n• Fried & spicy\n• High energy snack",
    "Murukku": "Murukku (100g):\n• Calories: ~460kcal\n• Crunchy rice snack\n• Festive favorite",
    "Thattai": "Thattai (100g):\n• Calories: ~420kcal\n• Flat savory\n• Tea-time snack",
    "Ribbon Pakoda": "Ribbon Pakoda (100g):\n• Calories: ~440kcal\n• Crispy rice flour snack",
    "Omapodi": "Omapodi (100g):\n• Calories: ~430kcal\n• Light sev\n• Seasoned with ajwain",
  };

  @override
  void initState() {
    super.initState();
    // Add welcome message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _chatMessages.add({
          "sender": "bot",
          "message": "Hey there! I'm your sweet assistant 🍬\nTell me how you're feeling or ask me about any sweet."
        });
      });
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _handleChatMessage(String message) {
    if (message.trim().isEmpty) return;
    setState(() {
      _chatMessages.add({"sender": "user", "message": message});
    });

    String normalizedInput = message
        .toLowerCase()
        .replaceAll("i'm", "i am")
        .replaceAll("im", "i am")
        .replaceAll(RegExp(r"\\bu\\b"), "you")
        .replaceAll(RegExp(r"\\bur\\b"), "your")
        .replaceAll(RegExp(r"\\br\\b"), "are")
        .replaceAll("feelin", "feeling");

    String response = _generateBotResponse(normalizedInput);

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _chatMessages.add({"sender": "bot", "message": response});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    });

    _chatController.clear();
  }

  String _generateBotResponse(String input) {
    if (input.contains("sad") || input.contains("upset") || input.contains("low")) {
      return "Feeling low? You can try Badam Halwa. It's sure to lift your mood.";
    } else if (input.contains("tired") || input.contains("sleepy") || input.contains("exhausted")) {
      return "Tired? Grab a Mysore Pak for quick energy or a Laddu to feel better.";
    } else if (input.contains("happy") || input.contains("joyful") || input.contains("excited")) {
      return "Nice! When you're happy, Rasgulla or Kaju Katli is a sweet way to celebrate!";
    } else if (input.contains("tell me about")) {
      for (var sweet in sweetInfo.keys) {
        if (input.contains(sweet.toLowerCase())) {
          return sweetInfo[sweet]!;
        }
      }
      return "Oops, I don't have info on that one right now.";
    } else if (input.contains("blood") || input.contains("sugar")) {
      double? sugarLevel = double.tryParse(RegExp(r"\\d+").stringMatch(input) ?? "");
      if (sugarLevel != null) {
        if (sugarLevel < 70) {
          return "Sugar's a bit low? You can go for Mysore Pak or Badam Halwa to get back up.";
        } else if (sugarLevel <= 140) {
          return "Looks normal! You can enjoy Rasgulla or Kalakand but just in moderation.";
        } else {
          return "Whoa, sugar's high. Stick to Mixture or Omapodi and skip syrupy stuff for now.";
        }
      } else {
        return "Just tell me your sugar level like 'My sugar is 110' and I got you.";
      }
    }
    return "Hey! Ask me anything sweet like 'Tell me about Jangiri' or how you're feeling right now.";
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      shape: StadiumBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightOrange,
      appBar: AppBar(
        title: Text('A2B Sweets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
        centerTitle: true,
        backgroundColor: _primaryOrange,
        elevation: 8,
        shadowColor: _darkOrange.withOpacity(0.5),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: Center(child: Icon(Icons.cake, size: 80, color: _primaryOrange)),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SweetListScreen()));
              },
              icon: Icon(Icons.explore),
              label: Text('Explore Our Sweets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _buildFeatureChip(Icons.star, "Popular", _primaryOrange),
                _buildFeatureChip(Icons.local_offer, "Offers", _darkOrange),
                _buildFeatureChip(Icons.cake, "Seasonal", _primaryOrange),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  final chat = _chatMessages[index];
                  final isUser = chat["sender"] == "user";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? _primaryOrange : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(isUser ? 12 : 0),
                          bottomRight: Radius.circular(isUser ? 0 : 12),
                        ),
                      ),
                      child: Text(
                        chat["message"]!,
                        style: TextStyle(color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: "Ask something sweet...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _handleChatMessage,
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _primaryOrange,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () => _handleChatMessage(_chatController.text),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryOrange,
        child: Icon(Icons.shopping_cart, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}
