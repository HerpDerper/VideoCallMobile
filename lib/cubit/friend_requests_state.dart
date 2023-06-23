part of 'friend_requests_cubit.dart';

@immutable
abstract class FriendRequestsState {}

class FriendRequestsInitial extends FriendRequestsState {}

class UpdateFriendRequests extends FriendRequestsState {
  final List<User> users;
  final List<FriendRequest> friendRequests;

  UpdateFriendRequests(this.users, this.friendRequests);
}

class ClearFriendRequests extends FriendRequestsState {
  final List<User> users;
  final List<FriendRequest> friendRequests;

  ClearFriendRequests(this.users, this.friendRequests);
}
