import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import '/utils/app_utils.dart';
import '/controllers/user_controller.dart';
import '/screens/registration_screen.dart';
import '/utils/shared_preferences_utils.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();

  @override
  void initState() {
    sharedPreferencesUtils.initSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: RichText(
          text: TextSpan(
            text: 'New User?  ',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            children: <TextSpan>[
              TextSpan(
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AppUtils.switchScreenWithoutReturn(const RegistrationScreen(), context);
                  },
                text: 'Register Now',
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/icon.png',
              width: 67,
              height: 67,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Email',
                      ),
                      controller: controllerEmail,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Email must not be empty';
                        }
                        return null;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                    child: TextFormField(
                      obscureText: true,
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
                        labelText: 'Password',
                      ),
                      controller: controllerPassword,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Password must not be empty';
                        }
                        return null;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.purple,
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  child: const Text(
                    'Login',
                  ),
                  onPressed: () async {
                    if (!key.currentState!.validate()) return;
                    String email = controllerEmail.text.toLowerCase().trim();
                    String password = controllerPassword.text;
                    try {
                      Response response = await UserController().signIn(email, password);
                      String token = response.data['data']['accessToken'];
                      await UserController(token: token).updateStatus();
                      sharedPreferencesUtils.setTokenToSharedPreferences(token);
                      AppUtils.switchScreenWithoutReturn(HomeScreen(token: token), context);
                    } catch (e) {
                      AppUtils.showInfoMessage('Invalid email or password', context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
