part of 'chats_cubit.dart';

@immutable
abstract class ChatsState {}

class ChatsInitial extends ChatsState {}

class UpdateChats extends ChatsState {
  final List<User> users;
  final List<Chat> chats;

  UpdateChats(this.users, this.chats);
}

class ClearChats extends ChatsState {
  final List<User> users;
  final List<Chat> chats;

  ClearChats(this.users, this.chats);
}
