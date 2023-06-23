import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '/models/user.dart';
import '/models/chat.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitial());

  List<User> users = [];
  List<Chat> chats = [];

  void setChats(List<User> users, List<Chat> chats) {
    this.users = users;
    this.chats = chats;
    emit(UpdateChats(users, chats));
  }

  void deleteChat(int index) {
    users.removeAt(index);
    chats.removeAt(index);
    if (users.isEmpty) {
      emit(ClearChats(users, chats));
    } else {
      emit(UpdateChats(users, chats));
    }
  }

  void clearChats() {
    users.clear();
    chats.clear();
    emit(ClearChats(users, chats));
  }
}
