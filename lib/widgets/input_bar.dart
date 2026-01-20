import 'package:flutter/material.dart';

class InputBar extends StatefulWidget{
  final Function(String) onSendMessage;
  const InputBar({Key? key, required this.onSendMessage}) : super(key : key);

  @override
  State<InputBar> createState() => _inputBarState();

  }

  class _inputBarState extends State<InputBar> {
  final TextEditingController _textController =TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _senMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty){
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
    Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Type Your Message...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (value) => _senMessage(),
              ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
              onPressed: _senMessage,
              mini: true,
              backgroundColor: Colors.blue,
              child: Icon(Icons.send),
          ),
        ],
      )
    );
  }



}