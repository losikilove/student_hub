import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/chat_model.dart';
import 'package:student_hub/services/message_service.dart';
import 'package:student_hub/services/socket_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageBody extends StatefulWidget {
  const MessageBody({super.key});

  @override
  State<MessageBody> createState() => _MessageBody();
}

class _MessageBody extends State<MessageBody> {
  final _searchController = TextEditingController();
  final IO.Socket socket = SocketService.builderSocket();
  @override
  void dispose() {
    // dispose the search controller when this widget has cleared on the widget tree
    _searchController.dispose();
    super.dispose();
  }
    @override
  void initState() {
    super.initState();
    addAuthorization();
  }
  // switch to switch account screen
  void onSwitchedToSwitchAccountScreen() {
    NavigationUtil.toSwitchAccountScreen(context);
  }

  Stream<List<ChatModel>> getChats() async* {
    final response = await MessageService.getMessage(context: context);
    if (response.statusCode == 200) {
      yield ChatModel.fromResponse(response, context);
    } else {
      throw Exception('Failed to load chats');
    }
  }//

  //connect socket
  void addAuthorization() {
    SocketService.addAuthorizationToSocket(socket: socket, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onSwitchedToSwitchAccountScreen,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search bar
            CustomTextfield(
              controller: _searchController,
              hintText: 'Search',
              prefixIcon: Icons.search,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            // chat listview
            Expanded(
              child: _chats(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chats(BuildContext context) {
    return StreamBuilder<List<ChatModel>>(
      stream: getChats(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildChatBlock(snapshot.data![index]);
              },
            );
        }
      },
    );
  }

  Widget _buildChatBlock(ChatModel chat) {
    // switch to the chat box
    void onSwitchedToChatBox() {
      NavigationUtil.toMessageDetail(context, chat, socket);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // divider
        const CustomDivider(
          isFullWidth: true,
        ),
        GestureDetector(
          onTap: onSwitchedToChatBox,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // avatar
              const Flexible(
                flex: 1,
                child: Icon(
                  Icons.account_circle,
                  size: 35,
                ),
              ),
              const SizedBox(
                width: SpacingUtil.smallHeight,
              ),
              Flexible(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // name text
                        CustomText(
                          text: chat.getName,
                          isBold: true,
                        ),
                        // datetime text
                        CustomText(
                          text: chat.getDateTime,
                          isItalic: true,
                          isOverflow: true,
                        ),
                      ],
                    ),
                    // profession text
                    CustomText(text: chat.getProfession),
                    const SizedBox(height: SpacingUtil.smallHeight),
                    // description text
                    const CustomText(
                      text:
                          'Clear expectation about your project or deliverables',
                      size: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
