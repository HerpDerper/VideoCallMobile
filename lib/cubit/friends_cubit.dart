import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '/models/friend.dart';
import '/models/user.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit() : super(FriendsInitial());

  List<User> users = [];
  List<Friend> friends = [];

  void setFriends(List<User> users, List<Friend> friends) {
    this.users = users;
    this.friends = friends;
    emit(UpdateFriends(users, friends));
  }

  void deleteFried(int index) {
    users.removeAt(index);
    friends.removeAt(index);
    if (users.isEmpty) {
      emit(ClearFriends(users, friends));
    } else {
      emit(UpdateFriends(users, friends));
    }
  }

  void clearFriends() {
    users.clear();
    friends.clear();
    emit(ClearFriends(users, friends));
  }
}
