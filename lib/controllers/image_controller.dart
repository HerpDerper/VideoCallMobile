import 'package:dio/dio.dart';

import '/models/image.dart';
import '/utils/url_utils.dart';

class ImageController {
  Dio DIO = Dio();
  final String token;
  ImageController({required this.token}) {
    _initDIO();
  }

  Future<Response> createImage(String fileName, String content) async {
    Response response = await DIO.put(URL.image.value, data: Image(fileName: fileName, content: content));
    return response;
  }

  Future<Response> getProfileImage() async {
    Response response = await DIO.get(URL.image.value);
    return response;
  }

  Future<Response> getImageByUserId(int id) async {
    Response response = await DIO.get('${URL.image.value}/$id');
    return response;
  }

  void _initDIO() {
    DIO.options.headers['Authorization'] = 'Bearer $token';
  }
}
