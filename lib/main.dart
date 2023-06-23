import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/chats_cubit.dart';
import 'cubit/friends_cubit.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'cubit/messages_cubit.dart';
import 'cubit/friend_requests_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((context) {
            return FriendRequestsCubit();
          }),
          child: const HomeScreen(
            token: '',
          ),
        ),
        BlocProvider(
          create: ((context) {
            return FriendsCubit();
          }),
          child: const HomeScreen(
            token: '',
          ),
        ),
        BlocProvider(
          create: ((context) {
            return ChatsCubit();
          }),
          child: const HomeScreen(
            token: '',
          ),
        ),
        BlocProvider(
          create: (context) => MessagesCubit(),
          child: const HomeScreen(
            token: '',
          ),
        ),
      ],
      child: const MaterialApp(
        home: AuthScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
