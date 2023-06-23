import 'package:freezed_annotation/freezed_annotation.dart';

part 'image.g.dart';
part 'image.freezed.dart';

@freezed
abstract class Image with _$Image {
  factory Image({int? id, String? content, String? fileName}) = _Image;

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
}
