import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/user.dart';
import '/models/chat.dart';
import '/models/image.dart' as imgMdl;
import 'messages_page.dart';
import '/utils/app_utils.dart';
import '/cubit/chats_cubit.dart';
import '/utils/image_utils.dart';
import '/widgets/dialog_widgets.dart';
import '/controllers/chat_controller.dart';
import '/controllers/image_controller.dart';
import '/controllers/friend_controller.dart';

class ChatsPage extends StatefulWidget {
  final User user;
  final String token;

  const ChatsPage({super.key, required this.user, required this.token});

  @override
  State<ChatsPage> createState() => ChatsPageState();
}

class ChatsPageState extends State<ChatsPage> with AfterLayoutMixin<ChatsPage> {
  TextEditingController controllerLogin = TextEditingController();
  late ChatController _chatController;
  late FriendController _friendController;
  List<User> _users = [];
  List<Chat> _chats = [];
  int _chatsCount = 0;
  late Timer _timer;

  Future<void> _getChats() async {
    Response response = await _chatController.getChats();
    if (response.data['message'].toString() == 'Chats not found') {
      context.read<ChatsCubit>().clearChats();
      return;
    }
    _users = (response.data['message'] as List).map((x) => User.fromJson(x)).toList();
    _chats = (response.data['data'] as List).map((x) => Chat.fromJson(x)).toList();
    _chatsCount = _chats.length;
    context.read<ChatsCubit>().setChats(_users, _chats);
  }

  Future<imgMdl.Image> _getImageByUserId(int id) async {
    Response response = await ImageController(token: widget.token).getImageByUserId(id);
    if (response.data['message'] == 'Image not found') {
      return imgMdl.Image(id: 0, content: '', fileName: '');
    }
    return imgMdl.Image.fromJson(response.data['data']);
  }

  void _checkChats() async {
    Response response = await _chatController.getChats();
    if (response.data['message'].toString() != 'Chats not found') {
      _chatsCount = (response.data['data'] as List).map((x) => Chat.fromJson(x)).toList().length;
      if (_chatsCount != _chats.length) {
        setState(() {
          _getChats();
        });
      }
    } else {
      setState(() {
        _users = [];
        _chats = [];
        _chatsCount = 0;
        context.read<ChatsCubit>().clearChats();
      });
    }
  }

  @override
  void initState() {
    _chatController = ChatController(token: widget.token);
    _friendController = FriendController(token: widget.token);
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) async {
      _checkChats();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 22, 20, 32),
        title: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: TextField(
              controller: controllerLogin,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search user by login',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.purple.shade800,
                  ),
                ),
                hintStyle: const TextStyle(
                  color: Colors.white70,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () async {
                    Response response = await _friendController.searchFriend(controllerLogin.text);
                    if (response.data['message'] == 'User not found') {
                      AppUtils.showInfoMessage('User not found', context);
                      return;
                    }
                    controllerLogin.clear();
                    User friendUser = User.fromJson(response.data['data']);
                    imgMdl.Image friendImage = await _getImageByUserId(friendUser.id!);
                    DialogWidgets(token: widget.token, context: context).showFriendInfoDialog(friendImage, friendUser);
                  },
                ),
              ),
              onSubmitted: (login) async {
                Response response = await _friendController.searchFriend(login);
                if (response.data['message'] == 'User not found') {
                  AppUtils.showInfoMessage('User not found', context);
                  return;
                }
                controllerLogin.clear();
                User friendUser = User.fromJson(response.data['data']);
                imgMdl.Image friendImage = await _getImageByUserId(friendUser.id!);
                DialogWidgets(token: widget.token, user: widget.user, context: context).showUserInfoDialog(friendImage, friendUser);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          if (state is UpdateChats) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: Card(
                    color: Colors.deepPurple,
                    child: ListTile(
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      trailing: PopupMenuButton(
                        tooltip: 'Actions',
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text(
                              'Delete chat',
                            ),
                            onTap: () {
                              _chatController.deleteChat(state.chats.elementAt(index).id!);
                              context.read<ChatsCubit>().deleteChat(index);
                            },
                          ),
                        ],
                      ),
                      title: Text(
                        state.users.elementAt(index).login!,
                      ),
                      subtitle: Text(
                        style: const TextStyle(color: Colors.grey),
                        state.users.elementAt(index).status! ? 'Online' : 'Offline',
                      ),
                      leading: FutureBuilder(
                        future: _getImageByUserId(state.users.elementAt(index).id!),
                        builder: (context, snapshotImage) {
                          if (snapshotImage.connectionState == ConnectionState.waiting) {
                            return const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 123, 118, 155),
                              ),
                            );
                          }
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: snapshotImage.data!.content == '' ? Colors.black : Colors.transparent,
                            backgroundImage: snapshotImage.data!.content == ''
                                ? null
                                : MemoryImage(
                                    ImageUtils.convertStringToUint8List(snapshotImage.data!.content!),
                                  ),
                            child: CircleAvatar(
                              radius: 27,
                              backgroundColor: Colors.transparent,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: state.users.elementAt(index).status! ? Colors.green : Colors.transparent,
                                  radius: 7,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        AppUtils.switchScreen(MessagesPage(token: widget.token, currentUser: widget.user, user: state.users.elementAt(index)), context);
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'Chats not found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
