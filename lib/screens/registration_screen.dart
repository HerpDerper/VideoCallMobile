import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import '/utils/app_utils.dart';
import '/screens/auth_screen.dart';
import '/controllers/user_controller.dart';
import '/utils/shared_preferences_utils.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> key = GlobalKey();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerDateBirth = TextEditingController();
  SharedPreferencesUtils sharedPreferencesUtils = SharedPreferencesUtils();

  @override
  void initState() {
    sharedPreferencesUtils.initSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 35, 55),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
        child: GestureDetector(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 15,
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  AppUtils.switchScreenWithoutReturn(const AuthScreen(), context);
                },
              text: 'Already registered?',
            ),
          ),
        ),
      ),
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
                'Create an account',
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
                      controller: controllerEmail,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Email must not be empty';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Email entered incorrectly';
                        }
                        return null;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                    child: TextFormField(
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
                      controller: controllerUsername,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Login must not be empty';
                        }
                        if (value.length < 4 || value.length >= 16) {
                          return 'Login must be from 8 to 16 characters';
                        }
                        return null;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                    child: TextFormField(
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
                        if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.=]).{8,16}$').hasMatch(value)) {
                          return 'Password must be from 8 to 16 characters, must contain letters, numbers and special characters';
                        }
                        return null;
                      }),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 30, 0),
                    child: TextFormField(
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
                        labelText: 'Date of birth',
                      ),
                      controller: controllerDateBirth,
                      validator: ((value) {
                        if (value == null || value.isEmpty) {
                          return 'Date of birth must not be empty';
                        }
                        return null;
                      }),
                      onTap: () async {
                        DateTime? pickedDate =
                            await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
                        if (pickedDate != null) {
                          controllerDateBirth.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                        }
                      },
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
                    'Register',
                  ),
                  onPressed: () async {
                    if (!key.currentState!.validate()) return;
                    String email = controllerEmail.text.toLowerCase();
                    String login = controllerUsername.text;
                    String password = controllerPassword.text;
                    String dateBirth = controllerDateBirth.text;
                    try {
                      Response response = await UserController().signUp(email, login, password, dateBirth);
                      String token = response.data['data']['accessToken'];
                      sharedPreferencesUtils.setTokenToSharedPreferences(token);
                      AppUtils.switchScreenWithoutReturn(HomeScreen(token: token), context);
                    } catch (e) {
                      AppUtils.showInfoMessage('Current email address is already in use', context);
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
