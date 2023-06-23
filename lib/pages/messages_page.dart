import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:after_layout/after_layout.dart';

import '/models/chat.dart';
import '/models/user.dart';
import '/models/image.dart' as imgMdl;
import '/models/message.dart';
import '/utils/app_utils.dart';
import '/utils/image_utils.dart';
import '/screens/call_screen.dart';
import '/widgets/chat_widgets.dart';
import '/cubit/messages_cubit.dart';
import '/utils/video_sdk_utils.dart';
import '/controllers/chat_controller.dart';
import '/controllers/image_controller.dart';
import '/controllers/message_controller.dart';

class MessagesPage extends StatefulWidget {
  final String token;
  final User currentUser;
  final User user;

  const MessagesPage({super.key, required this.token, required this.currentUser, required this.user});

  @override
  State<MessagesPage> createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> with AfterLayoutMixin<MessagesPage> {
  TextEditingController controllerMessage = TextEditingController();
  late ChatController _chatController;
  late MessageController _messageController;
  List<User> _users = [];
  List<Message> _messages = [];
  int _messagesCount = 0;
  late Timer _timer;
  late Chat _chat = Chat(id: 0, lastMessageTime: '', meetingID: '');

  Future<void> _beginCall() async {
    if (_chat.id == 0) {
      _createChat();
    }
    _getImageByUserId(widget.currentUser.id!).then((image) {
      AppUtils.switchScreen(CallScreen(meetingId: _chat.meetingID!, user: widget.currentUser, image: image), context);
    });
  }

  void _submitMessage() async {
    if (controllerMessage.text.isEmpty) {
      return;
    }
    if (_chat.meetingID == '') {
      _createChat().then((value) {
        _messageController.createMessage(_chat.id!, DateTime.now().toString(), controllerMessage.text);
        _chatController.updateLastMessageTime(_chat.id!);
        controllerMessage.clear();
        setState(() {
          _getMessages();
        });
      });
      return;
    }
    _messageController.createMessage(_chat.id!, DateTime.now().toString(), controllerMessage.text);
    _chatController.updateLastMessageTime(_chat.id!);
    controllerMessage.clear();
  }

  Future<Chat> _createChat() async {
    return _chat = await VideoSDKUtils.createMeeting().then((meetingID) async {
      Response response = await ChatController(token: widget.token).createChat(widget.user.id!, meetingID);
      return Chat.fromJson(response.data['data']);
    });
  }

  Future<imgMdl.Image> _getImageByUserId(int id) async {
    Response response = await ImageController(token: widget.token).getImageByUserId(id);
    if (response.data['message'] == 'Image not found') {
      return imgMdl.Image(id: 0, content: '', fileName: '');
    }
    return imgMdl.Image.fromJson(response.data['data']);
  }

  Future<void> _getChat() async {
    Response response = await _chatController.getChat(widget.user.id!);
    if (response.data['message'] == 'Successfully received') {
      _chat = Chat.fromJson(response.data['data']);
    }
  }

  void _getMessages() async {
    try {
      Response response = await _messageController.getMessages(_chat.id!);
      if (response.data['message'].toString() == 'Messages not found') {
        context.read<MessagesCubit>().clearMessages();
        return;
      }
      _users = (response.data['message'] as List).map((x) => User.fromJson(x)).toList();
      _messages = (response.data['data'] as List).map((x) => Message.fromJson(x)).toList();
      _messagesCount = _messages.length;
      context.read<MessagesCubit>().setMessages(_users, _messages);
    } catch (e) {}
  }

  void _deleteMessage(int index, int id) {
    _messageController.deleteMessage(id);
    context.read<MessagesCubit>().deleteMessage(index);
  }

  void _checkMessages() async {
    Response response = await _messageController.getMessages(_chat.id!);
    if (response.data['message'].toString() != 'Messages not found') {
      _messagesCount = (response.data['data'] as List).map((x) => Message.fromJson(x)).toList().length;
      if (_messagesCount != _messages.length) {
        setState(() {
          _getMessages();
        });
      }
    } else {
      setState(() {
        _users = [];
        _messages = [];
        _messagesCount = 0;
        context.read<MessagesCubit>().clearMessages();
      });
    }
  }

  @override
  void initState() {
    _chatController = ChatController(token: widget.token);
    _messageController = MessageController(token: widget.token);
    _getChat().then((value) {
      _getMessages();
    });
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) async {
      _checkMessages();
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
      backgroundColor: const Color.fromARGB(255, 47, 43, 68),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 29, 31),
        title: Row(
          children: [
            FutureBuilder(
              future: _getImageByUserId(widget.user.id!),
              builder: (context, snapshotImage) {
                if (snapshotImage.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 123, 118, 155),
                    ),
                  );
                }
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: snapshotImage.data!.content == '' ? Colors.black : Colors.transparent,
                  backgroundImage: snapshotImage.data!.content == ''
                      ? null
                      : MemoryImage(
                          ImageUtils.convertStringToUint8List(snapshotImage.data!.content!),
                        ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                widget.user.login!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
                widget.user.status! ? 'Online' : 'Offline',
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.phone,
              ),
              onPressed: () {
                _beginCall();
              },
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocBuilder<MessagesCubit, MessagesState>(
              builder: (context, state) {
                if (state is UpdateMessages) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return ChatWidgets.messagesCard(state.users.elementAt(index).id == widget.currentUser.id, state.messages.elementAt(index),
                          () => _deleteMessage(index, state.messages.elementAt(index).id!));
                    },
                  );
                }
                return const Center(
                  child: Text(
                    'Messages not found',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 47, 43, 68),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 73, 67, 105),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: TextField(
                controller: controllerMessage,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  labelText: 'Enter message',
                  prefixIcon: IconButton(
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _submitMessage();
                    },
                  ),
                ),
                onSubmitted: (value) {
                  _submitMessage();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
