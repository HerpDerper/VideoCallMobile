import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:after_layout/after_layout.dart';

import '/models/user.dart';
import '/models/image.dart' as imgMdl;
import '/utils/app_utils.dart';
import '/utils/image_utils.dart';
import '/models/friend_request.dart';
import '/cubit/friend_requests_cubit.dart';
import '/controllers/image_controller.dart';
import '/controllers/friend_request_controller.dart';

class FriendRequestsPage extends StatefulWidget {
  final User user;
  final String token;

  const FriendRequestsPage({super.key, required this.user, required this.token});

  @override
  State<FriendRequestsPage> createState() => FriendRequestsPageState();
}

class FriendRequestsPageState extends State<FriendRequestsPage> with AfterLayoutMixin<FriendRequestsPage> {
  late FriendRequestController _friendRequestController;
  List<User> _users = [];
  List<FriendRequest> _friendRequests = [];
  int _friendRequestsCount = 0;
  bool _isSendedRequests = false;
  late Timer _timer;

  void _submitFriendRequest(int id) async {
    _friendRequestController.submitFriendRequest(id);
    AppUtils.showInfoMessage('New friend added', context);
  }

  void _deleteFriendRequest(int id) async {
    _friendRequestController.deleteFriendRequest(id);
    AppUtils.showInfoMessage('Successfuly deleted', context);
  }

  void _getSendedFriendRequests() async {
    Response response = await _friendRequestController.getSendedFriendRequests();
    if (response.data['message'].toString() == 'Requests not found') {
      context.read<FriendRequestsCubit>().clearFriendRequests();
      return;
    }
    _users = (response.data['message'] as List).map((x) => User.fromJson(x)).toList();
    _friendRequests = (response.data['data'] as List).map((x) => FriendRequest.fromJson(x)).toList();
    context.read<FriendRequestsCubit>().setFriendRequests(_users, _friendRequests);
    _friendRequestsCount = _friendRequests.length;
  }

  void _getReceivedFriendRequests() async {
    Response response = await _friendRequestController.getReceivedFriendRequests();
    if (response.data['message'].toString() == 'Requests not found') {
      context.read<FriendRequestsCubit>().clearFriendRequests();
      return;
    }
    _users = (response.data['message'] as List).map((x) => User.fromJson(x)).toList();
    _friendRequests = (response.data['data'] as List).map((x) => FriendRequest.fromJson(x)).toList();
    _friendRequestsCount = _friendRequests.length;
    context.read<FriendRequestsCubit>().setFriendRequests(_users, _friendRequests);
  }

  Future<imgMdl.Image> _getImageByUserId(int id) async {
    Response response = await ImageController(token: widget.token).getImageByUserId(id);
    if (response.data['message'] == 'Image not found') {
      return imgMdl.Image(id: 0, content: '', fileName: '');
    }
    return imgMdl.Image.fromJson(response.data['data']);
  }

  void _checkFriendRequests() async {
    Response response;
    if (_isSendedRequests) {
      response = await _friendRequestController.getSendedFriendRequests();
    } else {
      response = await _friendRequestController.getReceivedFriendRequests();
    }
    if (response.data['message'].toString() != 'Requests not found') {
      _friendRequestsCount = (response.data['data'] as List).map((x) => FriendRequest.fromJson(x)).toList().length;
      if (_friendRequestsCount != _friendRequests.length) {
        setState(() {
          if (_isSendedRequests) {
            _getSendedFriendRequests();
          } else {
            _getReceivedFriendRequests();
          }
        });
      }
    } else {
      setState(() {
        _users = [];
        _friendRequests = [];
        _friendRequestsCount = 0;
        context.read<FriendRequestsCubit>().clearFriendRequests();
      });
    }
  }

  @override
  void initState() {
    _friendRequestController = FriendRequestController(token: widget.token);
    _getReceivedFriendRequests();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 7), (Timer timer) async {
      _checkFriendRequests();
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
        foregroundColor: Colors.white,
        title: Center(
          child: Row(
            children: [
              const Spacer(),
              PopupMenuButton(
                tooltip: 'Swap',
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Sended'),
                    onTap: () {
                      _getSendedFriendRequests();
                      _isSendedRequests = true;
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Received'),
                    onTap: () {
                      _getReceivedFriendRequests();
                      _isSendedRequests = false;
                    },
                  ),
                ],
                icon: const Icon(
                  Icons.flip_camera_android_sharp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<FriendRequestsCubit, FriendRequestsState>(
        builder: (context, state) {
          if (state is UpdateFriendRequests) {
            return ListView.builder(
              itemCount: state.friendRequests.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Card(
                    color: Colors.deepPurple,
                    child: ListTile(
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      trailing: PopupMenuButton(
                        tooltip: 'Actions',
                        itemBuilder: (context) => [
                          if (!_isSendedRequests)
                            PopupMenuItem(
                              child: const Text(
                                'Accept',
                              ),
                              onTap: () {
                                _submitFriendRequest(state.friendRequests.elementAt(index).id!);
                                context.read<FriendRequestsCubit>().deleteFriedRequest(index);
                              },
                            ),
                          PopupMenuItem(
                            child: const Text(
                              'Delete',
                            ),
                            onTap: () {
                              _deleteFriendRequest(state.friendRequests.elementAt(index).id!);
                              context.read<FriendRequestsCubit>().deleteFriedRequest(index);
                            },
                          ),
                        ],
                      ),
                      title: Text(
                        state.users.elementAt(index).login!,
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
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'Requests not found',
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
