import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/user.dart';
import '/models/image.dart' as imgMdl;
import 'messages_page.dart';
import '/models/friend.dart';
import '/utils/app_utils.dart';
import '/utils/image_utils.dart';
import '/cubit/friends_cubit.dart';
import '/widgets/dialog_widgets.dart';
import '/controllers/image_controller.dart';
import '/controllers/friend_controller.dart';

class FriendsPage extends StatefulWidget {
  final User user;
  final String token;

  const FriendsPage({super.key, required this.user, required this.token});

  @override
  State<FriendsPage> createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> with AfterLayoutMixin<FriendsPage> {
  TextEditingController controllerLogin = TextEditingController();
  late FriendController _friendController;
  List<User> _users = [];
  List<Friend> _friends = [];
  int _friendsCount = 0;
  late Timer _timer;

  void _getFriends() async {
    Response response = await _friendController.getFriends();
    if (response.data['message'].toString() == 'Friends not found') {
      context.read<FriendsCubit>().clearFriends();
      return;
    }
    _users = (response.data['message'] as List).map((x) => User.fromJson(x)).toList();
    _friends = (response.data['data'] as List).map((x) => Friend.fromJson(x)).toList();
    _friendsCount = _friends.length;
    context.read<FriendsCubit>().setFriends(_users, _friends);
  }

  Future<imgMdl.Image> _getImageByUserId(int id) async {
    Response response = await ImageController(token: widget.token).getImageByUserId(id);
    if (response.data['message'] == 'Image not found') {
      return imgMdl.Image(id: 0, content: '', fileName: '');
    }
    return imgMdl.Image.fromJson(response.data['data']);
  }

  void _checkFriends() async {
    Response response = await _friendController.getFriends();
    if (response.data['message'].toString() != 'Friends not found') {
      _friendsCount = (response.data['data'] as List).map((x) => User.fromJson(x)).toList().length;
      if (_friendsCount != _friends.length) {
        setState(() {
          _getFriends();
        });
      }
    } else {
      setState(() {
        _users = [];
        _friends = [];
        _friendsCount = 0;
        context.read<FriendsCubit>().clearFriends();
      });
    }
  }

  @override
  void initState() {
    _friendController = FriendController(token: widget.token);
    _getFriends();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) async {
      _checkFriends();
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
                hintText: 'Search new friend by login',
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
                    Response response = await FriendController(token: widget.token).searchFriend(controllerLogin.text);
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
                Response response = await FriendController(token: widget.token).searchFriend(login);
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
        ),
      ),
      body: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          if (state is UpdateFriends) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.deepPurple,
                  child: ListTile(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    trailing: PopupMenuButton(
                      tooltip: 'Actions',
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text(
                            'Write message',
                          ),
                          onTap: () async {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => AppUtils.switchScreen(
                                    MessagesPage(currentUser: widget.user, token: widget.token, user: state.users.elementAt(index)), context));
                          },
                        ),
                        PopupMenuItem(
                          child: const Text(
                            'Delete friend',
                          ),
                          onTap: () {
                            _friendController.deleteFriend(state.friends.elementAt(index).id!);
                            context.read<FriendsCubit>().deleteFried(index);
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
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'Friends not found',
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
