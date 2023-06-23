import 'package:dio/dio.dart';

import '/models/user.dart';
import '/utils/url_utils.dart';

class UserController {
  Dio DIO = Dio();
  String? token;
  UserController({this.token}) {
    _initDIO();
  }

  Future<Response> signUp(String email, String login, String password, String dateBirth) async {
    Response response = await DIO.put(URL.token.value, data: User(login: login, email: email, password: password, dateBirth: dateBirth));
    return response;
  }

  Future<Response> signIn(String email, String password) async {
    Response response = await DIO.post(URL.token.value, data: User(email: email, password: password));
    return response;
  }

  Future<Response> updateProfile(String login, String email) async {
    Response response = await DIO.put(URL.user.value, data: User(login: login, email: email));
    return response;
  }

  Future<Response> updatePassword(String oldPassword, String newPassword) async {
    Response response = await DIO.post(URL.user.value, queryParameters: {'newPassword': newPassword, 'oldPassword': oldPassword});
    return response;
  }

  Future<Response> updateStatus() async {
    Response response = await DIO.post('${URL.user.value}/0');
    return response;
  }

  Future<Response> deleteProfile() async {
    Response response = await DIO.delete(URL.user.value);
    return response;
  }

  Future<Response> getProfile() async {
    Response response = await DIO.get(URL.user.value);
    return response;
  }

  void _initDIO() {
    DIO.options.headers['Authorization'] = 'Bearer $token';
  }
}
