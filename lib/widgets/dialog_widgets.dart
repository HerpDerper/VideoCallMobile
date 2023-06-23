import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/models/user.dart';
import '/models/image.dart' as imgMdl;
import '/utils/app_utils.dart';
import '/utils/image_utils.dart';
import '/pages/messages_page.dart';
import '/controllers/user_controller.dart';
import '/controllers/image_controller.dart';
import '/controllers/friend_request_controller.dart';

class DialogWidgets {
  User? user;
  String token;
  imgMdl.Image? image;
  BuildContext context;

  DialogWidgets({this.user, required this.token, required this.context, this.image});

  void showUserInfoDialog(imgMdl.Image friendImage, User userForChat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 18, 17, 26),
          child: StatefulBuilder(
            builder: (context, snapshot) {
              return Container(
                width: 350,
                color: const Color.fromARGB(255, 18, 17, 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: FutureBuilder(
                        future: null,
                        builder: (context, snapshot) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: friendImage.content == '' ? Colors.black : Colors.transparent,
                            backgroundImage: friendImage.content == ''
                                ? null
                                : MemoryImage(
                                    ImageUtils.convertStringToUint8List(friendImage.content!),
                                  ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              child: Builder(
                                builder: (context) {
                                  return Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: userForChat.status! ? Colors.green : Colors.grey,
                                      radius: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            userForChat.login!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            userForChat.email!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            child: const Text(
                              'Close',
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            child: const Text(
                              'Write message',
                            ),
                            onPressed: () async {
                              Future.delayed(const Duration(seconds: 0), () => Navigator.pop(context))
                                  .then((value) => AppUtils.switchScreen(MessagesPage(currentUser: user!, token: token, user: userForChat), context));
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showFriendInfoDialog(imgMdl.Image friendImage, User friendUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 18, 17, 26),
          child: StatefulBuilder(
            builder: (context, snapshot) {
              return Container(
                width: 350,
                color: const Color.fromARGB(255, 18, 17, 26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: friendImage.content == '' ? Colors.black : Colors.transparent,
                        backgroundImage: friendImage.content == ''
                            ? null
                            : MemoryImage(
                                ImageUtils.convertStringToUint8List(friendImage.content!),
                              ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.transparent,
                          child: Builder(
                            builder: (context) {
                              return Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: friendUser.status! ? Colors.green : Colors.grey,
                                  radius: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            friendUser.login!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            friendUser.email!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              textStyle: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            child: const Text(
                              'Close',
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            child: const Text(
                              'Send friend request',
                            ),
                            onPressed: () async {
                              Response response = await FriendRequestController(token: token).createFriendRequest(friendUser.id!);
                              if (response.data['message'] == 'Friend request already exists') {
                                AppUtils.showInfoMessage('Friend request already exists', context);
                              } else {
                                AppUtils.showInfoMessage('Request was send', context);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showProfileSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 18, 17, 26),
          child: StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Container(
                width: 350,
                height: 325,
                color: const Color.fromARGB(255, 18, 17, 26),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            imgMdl.Image updatedImage = await _showFilePickDialog();
                            if (updatedImage != image) {
                              setState(() {
                                image = updatedImage;
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: image!.content == '' ? Colors.black : Colors.transparent,
                            backgroundImage: image!.content == ''
                                ? null
                                : MemoryImage(
                                    ImageUtils.convertStringToUint8List(image!.content!),
                                  ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.transparent,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: user!.status! ? Colors.green : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        user!.login!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit',
                                    ),
                                    onPressed: () {
                                      Future.delayed(const Duration(seconds: 0), () => Navigator.pop(context)).then((value) => _showEditLoginDialog());
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        user!.email!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit',
                                    ),
                                    onPressed: () {
                                      Future.delayed(const Duration(seconds: 0), () => Navigator.pop(context)).then((value) => _showEditEmailDialog());
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color.fromARGB(255, 93, 78, 190),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Change password',
                                  ),
                                  onPressed: () {
                                    Future.delayed(const Duration(seconds: 0), () => Navigator.pop(context)).then((value) => _showEditPasswordDialog());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.redAccent,
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          child: const Text(
                            'Delete account',
                          ),
                          onPressed: () {
                            UserController(token: token).deleteProfile();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showEditLoginDialog() async {
    TextEditingController controllerLogin = TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          child: SizedBox(
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerLogin,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Login must not be empty';
                            }
                            if (text.length < 8 || text.length >= 16) {
                              return 'Login must be from 8 to 16 characters';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Login',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () async {
                            try {
                              String login = controllerLogin.text;
                              await UserController(token: token).updateProfile(login, user!.email!);
                              user = User(id: user!.id, login: login, email: user!.email, dateBirth: user!.dateBirth, status: user!.status);
                              AppUtils.showInfoMessage('Successful login update', context);
                              Navigator.pop(context);
                            } catch (e) {
                              AppUtils.showInfoMessage('Current login is already in use', context);
                            }
                          },
                          child: const Text(
                            "Submit",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditEmailDialog() async {
    TextEditingController controllerEmail = TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          child: SizedBox(
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerEmail,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Email must not be empty';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(text)) {
                              return 'Email entered incorrectly';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Email',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            try {
                              String email = controllerEmail.text.toLowerCase();
                              await UserController(token: token).updateProfile(user!.login!, email);
                              user = User(id: user!.id, login: user!.login, email: email, dateBirth: user!.dateBirth, status: user!.status);
                              AppUtils.showInfoMessage('Successful email update', context);
                              Navigator.pop(context);
                            } catch (e) {
                              AppUtils.showInfoMessage('Current email address is already in use', context);
                            }
                          },
                          child: const Text(
                            "Submit",
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditPasswordDialog() {
    TextEditingController controllerOldPassword = TextEditingController();
    TextEditingController controllerNewPassword = TextEditingController();
    TextEditingController controllerNewPasswordSubmit = TextEditingController();
    GlobalKey<FormState> key = GlobalKey();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 24, 19, 54),
          child: SizedBox(
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controllerOldPassword,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'Old password must not be empty';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'Old password',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        TextFormField(
                          controller: controllerNewPassword,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'New password must not be empty';
                            }
                            if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,16}$').hasMatch(text)) {
                              return 'New password must be from 8 to 16 characters, must contain letters, numbers and special characters';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'New password',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        TextFormField(
                          controller: controllerNewPasswordSubmit,
                          validator: ((text) {
                            if (text == null || text.isEmpty) {
                              return 'New password submit must not be empty';
                            }
                            return null;
                          }),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            labelText: 'New password submit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () async {
                            try {
                              String oldPassword = controllerOldPassword.text;
                              String newPassword = controllerNewPassword.text;
                              String newPasswordSubmit = controllerNewPasswordSubmit.text;
                              if (newPasswordSubmit != newPassword) {
                                AppUtils.showInfoMessage('Passwords do not match', context);
                                return;
                              }
                              await UserController(token: token).updatePassword(oldPassword, newPassword);
                              AppUtils.showInfoMessage('Successful password update', context);
                              Navigator.pop(context);
                            } catch (e) {
                              AppUtils.showInfoMessage('Invalid password', context);
                            }
                          },
                          child: const Text(
                            'Submit',
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 63, 57, 102),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Back',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<imgMdl.Image> _showFilePickDialog() async {
    imgMdl.Image updatedImage = image!;
    try {
      final newImage = await ImageUtils.pickImage();
      if (newImage == null) return updatedImage;
      File? croppedImage = await ImageUtils.cropImage(newImage);
      if (croppedImage == null) return updatedImage;
      Uint8List? bytes = await ImageUtils.readFileByte(croppedImage);
      String fileContent = ImageUtils.convertUint8ListToString(bytes!);
      fileContent = fileContent.replaceAll('\u0000', 'nullval');
      await ImageController(token: token).createImage(croppedImage.path, fileContent);
      updatedImage = imgMdl.Image(id: 0, content: fileContent, fileName: croppedImage.path);
      AppUtils.showInfoMessage('Successful image update', context);
    } catch (e) {
      AppUtils.showInfoMessage('Error', context);
    }
    return updatedImage;
  }
}
