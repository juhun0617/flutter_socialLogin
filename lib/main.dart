import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'MainPage.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? user; // User 변수 선언

  Future<void> signInWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _account = await _googleSignIn.signIn();
    if (_account != null) {
      GoogleSignInAuthentication _authentication =
          await _account.authentication;
      OAuthCredential _googleCredential = GoogleAuthProvider.credential(
        idToken: _authentication.idToken,
        accessToken: _authentication.accessToken,
      );
      try {
        UserCredential _credential =
            await _firebaseAuth.signInWithCredential(_googleCredential);
        setState(() {
          user = _credential.user; // User 객체 저장
        });

        // 로그인 성공, 메인 페이지로 이동
        if (user != null) {
          navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
            builder: (context) => MainPage(user: user!),
          ));
        }
      } catch (e) {
        // 오류 처리
        print(e);
      }
    }
  }

  void onClicked() {
    signInWithGoogle(context);
  }

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  void _checkLoggedInUser() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        // 로그인된 사용자가 있다면 메인 페이지로 이동
        navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
          builder: (context) => MainPage(user: user!),
        ));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'AIO에 오신 것을\n환영합니다',
                    style: TextStyle(fontSize: 35, fontFamily: 'Jalnan'),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(
                          270,
                          50,
                        ),
                        elevation: 5,
                        backgroundColor: const Color(0xFF45BE5E)),
                    onPressed: () => onClicked(),
                    child: const Text(
                      '이메일로 가입하기',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(
                          270,
                          50,
                        ),
                        elevation: 5,
                        backgroundColor: Colors.white),
                    onPressed: () => onClicked(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/Image/google.png"),
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '구글 계정으로 가입',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
