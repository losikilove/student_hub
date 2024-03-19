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
  List<ChatUser> _typing  = <ChatUser>[];
  getData(ChatMessage message)async{
    _typing.add(_anotherUser);
    _message.insert(0, message);

    setState(() {
      
    });
    await Future.delayed(Duration(seconds: 1));
    ChatMessage demo = ChatMessage(
      user: _anotherUser,
      createdAt: DateTime.now(),
      text: 'showSchedule',
      customProperties: {
        'appointment': {
          'date': '2024-03-20',
          'time': '10:00 AM',
          'description': 'Consultation with Dr. Strange'
        }
      }
    );
    _message.insert(0, demo);
    _typing.remove(_anotherUser);
    setState(() {
      
    });

  }
  @override
  void initState(){
    super.initState();
  }

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
        typingUsers: _typing,
        currentUser: _currentUser,
        onSend: (ChatMessage message){
          getData(message);
        },
        messages: _message,
        inputOptions: InputOptions(
          cursorStyle: CursorStyle(color: ColorUtil.primary),
        ),
        messageOptions: MessageOptions(
          currentUserContainerColor: ColorUtil.primary,
          containerColor: Color.fromARGB(255, 255, 255, 255),
          messageTextBuilder:(message, previousMessage, nextMessage) {
            if(message.text == 'showSchedule'){
               var appointment = message.customProperties!['appointment'];
                return Card(
                  child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Appointment'),
                  subtitle: Text('${appointment['description']} on ${appointment['date']} at ${appointment['time']}'),
              ),
            );
            }
            else{
              
              return Text(message.text, style: TextStyle(color: Colors.black,),);
            }
              
          },
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