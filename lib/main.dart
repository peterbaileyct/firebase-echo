import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Echo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EchoScreen(),
    );
  }
}

class EchoScreen extends StatefulWidget {
  const EchoScreen({super.key});

  @override
  State<EchoScreen> createState() => _EchoScreenState();
}

class _EchoScreenState extends State<EchoScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();

  void _submitMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add(_textController.text);
        _textController.clear();
      });
      
      // Scroll to the bottom after adding a message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Echo'),
      ),
      body: Column(
        children: [
          // Message display area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(_messages[index]),
                  ),
                );
              },
            ),
          ),
          // Input area
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submitMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _submitMessage,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}