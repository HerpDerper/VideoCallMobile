part of 'messages_cubit.dart';

@immutable
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class UpdateMessages extends MessagesState {
  final List<User> users;
  final List<Message> messages;

  UpdateMessages(this.users, this.messages);
}

class ClearMessages extends MessagesState {
  final List<User> users;
  final List<Message> messages;

  ClearMessages(this.users, this.messages);
}
