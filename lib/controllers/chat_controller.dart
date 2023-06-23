import 'package:dio/dio.dart';

import '/models/chat.dart';
import '/utils/url_utils.dart';

class ChatController {
  Dio DIO = Dio();
  final String token;
  ChatController({required this.token}) {
    _initDIO();
  }

  Future<Response> createChat(int id, String meetingID) async {
    Response response = await DIO.put('${URL.chat.value}/$id', data: Chat(lastMessageTime: DateTime.now().toString(), meetingID: meetingID));
    return response;
  }

  Future<Response> updateLastMessageTime(int id) async {
    Response response = await DIO.post('${URL.chat.value}/$id');
    return response;
  }

  Future<Response> deleteChat(int id) async {
    Response response = await DIO.delete('${URL.chat.value}/$id');
    return response;
  }

  Future<Response> getChat(int id) async {
    Response response = await DIO.get('${URL.chat.value}/$id');
    return response;
  }

  Future<Response> getChats() async {
    Response response = await DIO.get(URL.chat.value);
    return response;
  }

  void _initDIO() {
    DIO.options.headers['Authorization'] = 'Bearer $token';
  }
}
