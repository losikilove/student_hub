import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:student_hub/utils/api_util.dart';

class SocketService {
  static const String _socketUrl = '${ApiUtil.baseUrl}';
  static IO.Socket connectSocket({required String token}){
    return IO.io(
      _socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    )..connect();
  }

  static void addAuthorizationToSocket({required IO.Socket socket, required String token}){
    socket.io..options?['extraHeaders'] = {
      'Authorization': 'Bearer  $token',
    };
  }

  static void disconnectSocket({required IO.Socket socket}){
    socket.disconnect();
  }

  static void sendMessageSocket({required IO.Socket socket, required String message}){
    socket.emit('send_message', message);
  }

  static void receiveMessageSocket({required IO.Socket socket, required Function(dynamic) onMessage}){
    socket.on('receive_message', (data) => onMessage(data));
  }
}