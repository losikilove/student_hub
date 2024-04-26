import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/utils/api_util.dart';

class SocketService {
  static const String _socketUrl = 'https://api.studenthub.dev';
  static IO.Socket builderSocket() {
    return IO.io(
      _socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
  }

  static void addAuthorizationToSocket(
      {required IO.Socket socket, required BuildContext context}) {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.token!;
    socket.io
      .options?['extraHeaders'] = {
        'Authorization': 'Bearer  $token',
      };
  }

  static void disconnectSocket({required IO.Socket socket}) {
    socket.disconnect();
  }
}
