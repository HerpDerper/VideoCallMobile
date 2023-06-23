import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend.g.dart';
part 'friend.freezed.dart';

@freezed
abstract class Friend with _$Friend {
  factory Friend({int? id}) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
}
