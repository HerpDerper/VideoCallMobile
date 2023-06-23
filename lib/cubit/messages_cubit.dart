import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '/models/user.dart';
import '/models/message.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  List<User> users = [];
  List<Message> messages = [];

  void setMessages(List<User> users, List<Message> messages) {
    this.users = users;
    this.messages = messages;
    emit(UpdateMessages(users, messages));
  }

  void deleteMessage(int index) {
    users.removeAt(index);
    messages.removeAt(index);
    if (users.isEmpty) {
      emit(ClearMessages(users, messages));
    } else {
      emit(UpdateMessages(users, messages));
    }
  }

  void clearMessages() {
    users.clear();
    messages.clear();
    emit(ClearMessages(users, messages));
  }
}
