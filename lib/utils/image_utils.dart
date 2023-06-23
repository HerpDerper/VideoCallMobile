import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageUtils {
  static Future<XFile?> pickImage() async => await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

  static Future<File?> cropImage(XFile file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(sourcePath: file.path, cropStyle: CropStyle.circle, compressQuality: 100);
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  static Future<Uint8List?> readFileByte(File file) async {
    late Uint8List bytes;
    await file.readAsBytes().then((byte) {
      bytes = Uint8List.fromList(byte);
    });
    return bytes;
  }

  static Uint8List convertStringToUint8List(String content) {
    content = content.replaceAll('nullval', '\u0000');
    final List<int> codeUnits = content.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  static String convertUint8ListToString(List<int> uint8list) {
    return String.fromCharCodes(uint8list);
  }
}
