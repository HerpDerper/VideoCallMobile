import 'package:dio/dio.dart';

import '/models/message.dart';
import '/utils/url_utils.dart';

class MessageController {
  Dio DIO = Dio();
  final String token;
  MessageController({required this.token}) {
    _initDIO();
  }

  Future<Response> createMessage(int id, String dateSent, String text) async {
    Response response = await DIO.put('${URL.message.value}/$id', data: Message(dateSent: dateSent, text: text));
    return response;
  }

  Future<Response> deleteMessage(int id) async {
    Response response = await DIO.delete('${URL.message.value}/$id');
    return response;
  }

  Future<Response> getMessages(int id) async {
    Response response = await DIO.get('${URL.message.value}/$id');
    return response;
  }

  void _initDIO() {
    DIO.options.headers['Authorization'] = 'Bearer $token';
  }
}
