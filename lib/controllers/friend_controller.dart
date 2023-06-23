import 'package:dio/dio.dart';

import '/utils/url_utils.dart';

class FriendController {
  Dio DIO = Dio();
  final String token;
  FriendController({required this.token}) {
    _initDIO();
  }

  Future<Response> deleteFriend(int id) async {
    Response response = await DIO.delete('${URL.friend.value}/$id');
    return response;
  }

  Future<Response> searchFriend(String login) async {
    Response response = await DIO.post(URL.friend.value, queryParameters: {'login': login});
    return response;
  }

  Future<Response> getFriends() async {
    Response response = await DIO.get(URL.friend.value);
    return response;
  }

  void _initDIO() {
    DIO.options.headers['Authorization'] = 'Bearer $token';
  }
}
