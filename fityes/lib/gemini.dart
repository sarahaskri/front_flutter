import 'package:fityes/chatbotModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class geminiChatbot extends StatefulWidget {
  const geminiChatbot({super.key});

  @override
  State<geminiChatbot> createState() => _geminiChatbotState();
}

class _geminiChatbotState extends State<geminiChatbot> {
  static const apiKey = 'AIzaSyDNcuYMB4GT-emcvpOdCqO0r1RuqYjTS3Q';
final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  TextEditingController messageController = TextEditingController();
  final List<modelChatbot> chat = [];

  Future<void> sendMessage() async {
    final message = messageController.text;
    setState(() {
      messageController.clear();
      chat.add(modelChatbot(
        isUser: true,
        message: message,
        time: DateTime.now(),
      ));
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
        setState(() {
      chat.add(modelChatbot(
        isUser: false,
        message: response.text ??"",
        time: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: const Text('Gemini Chatbot'),
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: chat.length,
                    itemBuilder: (context, index) {
                      final message = chat[index];
                      return userPrompt(
                        isUser: message.isUser,
                        message: message.message,
                        time: message.time,
                      );
                    })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container userPrompt(
      {required final bool isUser,
      required String message,
        required DateTime time}) {
      final formattedTime = DateFormat('HH:mm aa').format(time);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 15 : 80, right: isUser ? 80 : 15),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 