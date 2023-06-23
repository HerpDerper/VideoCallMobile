import 'package:dio/dio.dart';

import '/utils/url_utils.dart';

class FriendRequestController {
  Dio DIO = Dio();
  final String token;
  FriendRequestController({required this.token}) {
    _initDIO();
  }

  Future<Response> createFriendRequest(int id) async {
    Response response = await DIO.put('${URL.friendRequest.value}/$id');
    return response;
  }

  Future<Response> submitFriendRequest(int id) async {
    Response response = await DIO.post('${URL.friendRequest.value}/$id');
    return response;
  }

  Future<Response> deleteFriendRequest(int id) async {
    Response response = await DIO.delete('${URL.friendRequest.value}/$id');
    return response;
  }

  Future<Response> getSendedFriendRequests() async {
    Response response = await DIO.post(URL.friendRequest.value);
    return response;
  }

  Future<Response> getReceivedFriendRequests() async {
    Response response = await DIO.get(URL.friendRequest.value);
    return response;
  }

  void _initDIO() {
    DIO.options.headers['Authorization'] = 'Bearer $token';
  }
}
