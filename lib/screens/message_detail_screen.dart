import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/utils/color_util.dart';

class MessageBodyPartChat extends StatefulWidget {
  const MessageBodyPartChat({super.key});

  @override
  State<MessageBodyPartChat> createState() => _MessageBodyPartChatState();
}

class _MessageBodyPartChatState extends State<MessageBodyPartChat> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'phat',lastName: 'bo');
  final ChatUser _anotherUser = ChatUser(id: '2', firstName: 'nhat',lastName: 'bo');
  List<ChatMessage> _message = <ChatMessage>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'chat',
        onPressed: () {
          
        },
        currentContext: context,
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: (ChatMessage message){
          getChatResponse(message);
        },
        messages: _message,
        inputOptions: InputOptions(
          alwaysShowSend: true,
          cursorStyle: CursorStyle(color: ColorUtil.primary)
        ),
        ),
    );
  }
  Future<void> getChatResponse(ChatMessage message) async {
    setState(() {
      _message.insert(0, message);
    });
  }
}