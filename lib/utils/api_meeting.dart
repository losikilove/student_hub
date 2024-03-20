import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJiY2JhNTUwYy0zMTczLTRhYTgtYmExNC0xY2YzOGFkNTFiMDIiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcxMDkxMTM5MSwiZXhwIjoxNzExNTE2MTkxfQ.HqZm52o4anT9IBRdKPwY5i_vVMVDthKUtF31XUclSj4";
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomID'];
}