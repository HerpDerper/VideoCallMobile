import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '/models/user.dart';
import '/models/friend_request.dart';

part 'friend_requests_state.dart';

class FriendRequestsCubit extends Cubit<FriendRequestsState> {
  FriendRequestsCubit() : super(FriendRequestsInitial());

  List<User> users = [];
  List<FriendRequest> friendRequests = [];

  void setFriendRequests(List<User> users, List<FriendRequest> friendRequests) {
    this.users = users;
    this.friendRequests = friendRequests;
    emit(UpdateFriendRequests(users, friendRequests));
  }

  void deleteFriedRequest(int index) {
    users.removeAt(index);
    friendRequests.removeAt(index);
    if (users.isEmpty) {
      emit(ClearFriendRequests(users, friendRequests));
    } else {
      emit(UpdateFriendRequests(users, friendRequests));
    }
  }

  void clearFriendRequests() {
    users.clear();
    friendRequests.clear();
    emit(ClearFriendRequests(users, friendRequests));
  }
}
