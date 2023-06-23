import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_request.g.dart';
part 'friend_request.freezed.dart';

@freezed
abstract class FriendRequest with _$FriendRequest {
  factory FriendRequest({int? id}) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);
}
