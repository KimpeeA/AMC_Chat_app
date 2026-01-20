import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '/services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();
  // Key for the AnimatedList to make messages "slide" in
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void addMessage(String text, bool isUser) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        isUserMessage: isUser,
        timestamp: DateTime.now(),
      ));
    });
    // Triggers the animation for the new item
    _listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 500));
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0, // Because it's reverse: true, 0 is the bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> handleSend(String text) async {
    addMessage(text, true); // User message

    // 🔥 COOL FEATURE: Modern Loading State
    addMessage('Typing...', false);

    try {
      final aiResponse = await GeminiService.sendMessage(text);

      setState(() {
        messages.removeAt(0); // Remove "Typing..."
        _listKey.currentState?.removeItem(0, (context, animation) => const SizedBox());
      });

      addMessage(aiResponse, false); // Real response
    } catch (e) {
      setState(() {
        messages.removeAt(0);
        _listKey.currentState?.removeItem(0, (context, animation) => const SizedBox());
      });
      addMessage('❌ Error: $e', false);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // COOL FEATURE: Aesthetic Background Gradient
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F9FD), Color(0xFFECE9E6)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Make scaffold transparent to show gradient
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.8), // Glassmorphism effect
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, color: Colors.deepPurple, size: 20),
              const SizedBox(width: 8),
              const Text(
                'KIMPS AI',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 80, color: Colors.deepPurple.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    const Text('Say hello to your AI friend!',
                        style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              )
                  : AnimatedList(
                key: _listKey,
                controller: scrollController,
                reverse: true, // Keep latest message at the bottom
                initialItemCount: messages.length,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                itemBuilder: (context, index, animation) {
                  // COOL FEATURE: Slide & Fade Animation for new messages
                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: MessageBubble(
                        message: messages[messages.length - 1 - index],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input Area with a slight shadow for depth
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
                ],
              ),
              child: InputBar(onSendMessage: handleSend),
            ),
          ],
        ),
      ),
    );
  }
}