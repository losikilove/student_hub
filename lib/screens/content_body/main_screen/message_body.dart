import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/models/chat_model.dart';
import 'package:student_hub/utils/spacing_util.dart';

class MessageBody extends StatefulWidget {
  const MessageBody({super.key});

  @override
  State<MessageBody> createState() => _MessageBody();
}

class _MessageBody extends State<MessageBody> {
  final _searchController = TextEditingController();
  List<ChatModel> _chats = [
    ChatModel(
      'Luis Pham',
      'Senior frontend developer (Fintech)',
      DateTime(2024, 6, 6, 12, 12),
      Icons.person,
    ),
    ChatModel(
      'Luis Pham',
      'Senior frontend developer (Fintech)',
      DateTime(2024, 6, 6, 12, 14),
      Icons.person_2_outlined,
    ),
    ChatModel(
      'Luis Pham',
      'Senior frontend developer (Fintech)',
      DateTime(2024, 6, 6, 12, 15),
      Icons.person_2_outlined,
    ),
  ];

  @override
  void dispose() {
    // dispose the search controller when this widget has cleared on the widget tree
    _searchController.dispose();

    super.dispose();
  }

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
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
              child: ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats[index];
                  return _buildChatBlock(chat);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBlock(ChatModel chat) {
    // switch to the chat box
    void onSwitchedToChatBox() {}

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
              Flexible(
                flex: 1,
                child: Icon(
                  chat.getAvatar,
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
