part of 'friends_cubit.dart';

@immutable
abstract class FriendsState {}

class FriendsInitial extends FriendsState {}

class UpdateFriends extends FriendsState {
  final List<User> users;
  final List<Friend> friends;

  UpdateFriends(this.users, this.friends);
}

class ClearFriends extends FriendsState {
  final List<User> users;
  final List<Friend> friends;

  ClearFriends(this.users, this.friends);
}
