import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

import '/models/user.dart';
import '/models/image.dart' as imgMdl;
import '/utils/app_utils.dart';
import '/pages/chats_page.dart';
import '/pages/friends_page.dart';
import '/screens/auth_screen.dart';
import '/widgets/dialog_widgets.dart';
import '/pages/friend_requests_page.dart';
import '/controllers/user_controller.dart';
import '/controllers/image_controller.dart';
import '/utils/shared_preferences_utils.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  User _user = User();
  imgMdl.Image _image = imgMdl.Image();
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();
  int _currentIndex = 0;
  String _appBarTitle = 'Friends';

  void _updateState(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
      switch (_currentIndex) {
        case 0:
          _appBarTitle = 'Friends';
          break;
        case 1:
          _appBarTitle = 'Friend requests';
          break;
        case 2:
          _appBarTitle = 'Chats';
          break;
      }
    });
  }

  void _logOut() {
    sharedPreferencesUtils.sharedPreferences!.clear();
    UserController(token: widget.token).updateStatus();
    AppUtils.switchScreenWithoutReturn(const AuthScreen(), context);
  }

  Future<void> _getProfile() async {
    Response response = await UserController(token: widget.token).getProfile();
    _user = User.fromJson(response.data['data']);
  }

  void _getProfileImage() async {
    Response response = await ImageController(token: widget.token).getProfileImage();
    if (response.data['message'] == 'Image not found') {
      _image = imgMdl.Image(id: 0, content: '', fileName: '');
      return;
    }
    _image = imgMdl.Image.fromJson(response.data['data']);
  }

  @override
  void initState() {
    sharedPreferencesUtils.initSharedPreferences();
    _getProfile().then((value) {
      _getProfileImage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 12, 17),
        title: Text(_appBarTitle),
      ),
      drawer: SidebarX(
        showToggleButton: false,
        controller: SidebarXController(
          selectedIndex: _currentIndex,
          extended: true,
        ),
        theme: SidebarXTheme(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 27, 24, 43),
          ),
          textStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
          ),
          itemTextPadding: const EdgeInsets.only(
            left: 30,
          ),
          selectedItemTextPadding: const EdgeInsets.only(
            left: 30,
          ),
          selectedItemDecoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                blurStyle: BlurStyle.solid,
                color: Colors.deepPurpleAccent,
              )
            ],
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
            size: 20,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.white,
            size: 20,
          ),
        ),
        extendedTheme: const SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 27, 24, 43),
          ),
        ),
        headerBuilder: (context, extended) {
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('images/icon.png'),
            ),
          );
        },
        items: [
          SidebarXItem(
            icon: Icons.emoji_people_rounded,
            label: 'Friends',
            onTap: () {
              _updateState(0);
            },
          ),
          SidebarXItem(
            icon: Icons.person_add_rounded,
            label: 'Friend requests',
            onTap: () {
              _updateState(1);
            },
          ),
          SidebarXItem(
            icon: Icons.forum_rounded,
            label: 'Chats',
            onTap: () {
              _updateState(2);
            },
          ),
        ],
        footerItems: [
          SidebarXItem(
            icon: Icons.settings,
            label: 'Profile settings',
            onTap: () {
              _getProfile().then((value) {
                _getProfileImage();
              });
              DialogWidgets(image: _image, user: _user, token: widget.token, context: context).showProfileSettingsDialog();
            },
          ),
          SidebarXItem(
            icon: Icons.logout,
            label: 'Log out',
            onTap: () {
              _logOut();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          FriendsPage(user: _user, token: widget.token),
          FriendRequestsPage(user: _user, token: widget.token),
          ChatsPage(user: _user, token: widget.token),
        ],
      ),
    );
  }
}
