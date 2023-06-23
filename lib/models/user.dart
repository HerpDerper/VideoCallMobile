import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  factory User({int? id, String? login, String? email, String? dateBirth, String? password, bool? status}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
