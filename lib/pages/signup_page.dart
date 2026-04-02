// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panda_login/pages/login_page.dart';
import 'package:rive/rive.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  late String _animationURL;
  Artboard? _teddyArtboard;
  SMITrigger? _successTrigger, _failTrigger;
  SMIBool? _isHandsUp, _isChecking;
  SMINumber? _numLook;
  StateMachineController? _stateMachineController;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _animationURL = 'assets/2244-7248-animated-login-character.riv';

    rootBundle.load(_animationURL).then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      _stateMachineController =
          StateMachineController.fromArtboard(artboard, 'Login Machine');

      if (_stateMachineController != null) {
        artboard.addController(_stateMachineController!);

        for (var element in _stateMachineController!.inputs) {
          if (element.name == 'trigSuccess') {
            _successTrigger = element as SMITrigger;
          } else if (element.name == 'trigFail') {
            _failTrigger = element as SMITrigger;
          } else if (element.name == 'isHandsUp') {
            _isHandsUp = element as SMIBool;
          } else if (element.name == 'isChecking') {
            _isChecking = element as SMIBool;
          } else if (element.name == 'numLook') {
            _numLook = element as SMINumber;
          }
        }
      }

      setState(() {
        _teddyArtboard = artboard;
      });
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _stateMachineController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 300,
                      width: 400,
                      child: _teddyArtboard == null
                          ? const CircularProgressIndicator()
                          : Rive(
                              artboard: _teddyArtboard!,
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(bottom: 15),
                        margin: const EdgeInsets.only(bottom: 15 * 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 30),
                              const Text(
                                'YENİ HESAP OLUŞTUR',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                controller: _name,
                                validator: (value) => value!.isEmpty
                                    ? 'Adınızı ve Soyadınızı Giriniz'
                                    : null,
                                onTap: () {
                                  lookOnTheField();
                                },
                                onChanged: (value) {
                                  moveEyeBalls(value);
                                },
                                style: const TextStyle(fontSize: 14),
                                cursorColor: Colors.red,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'AD SOYAD',
                                  labelText: 'AD SOYAD',
                                  labelStyle: TextStyle(color: Colors.black),
                                  iconColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  focusColor: Colors.red,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _email,
                                validator: (value) => value!.contains('@')
                                    ? null
                                    : 'Geçerli Bir Email Giriniz',
                                onTap: () {
                                  lookOnTheField();
                                },
                                onChanged: (value) {
                                  moveEyeBalls(value);
                                },
                                style: const TextStyle(fontSize: 14),
                                cursorColor: Colors.red,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: 'EMAİL',
                                  labelText: 'EMAİL',
                                  labelStyle: TextStyle(color: Colors.black),
                                  iconColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  focusColor: Colors.red,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _password,
                                obscureText: _isObscure,
                                validator: (value) => value!.length < 6
                                    ? 'Şifre en az 6 Karakter Olmalı'
                                    : null,
                                onTap: () {
                                  handsOnTheEyes();
                                },
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(fontSize: 14),
                                cursorColor: Colors.red,
                                decoration: InputDecoration(
                                  hintText: 'ŞİFRE',
                                  labelText: 'ŞİFRE',
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                        _isHandsUp?.change(_isObscure);
                                      });
                                    },
                                    icon: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(_isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  focusColor: Colors.red,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    try {
                                      UserCredential _user = await firebaseAuth
                                          .createUserWithEmailAndPassword(
                                              email: _email.text.trim(),
                                              password: _password.text.trim());
                                      await _user.user!
                                          .updateDisplayName(_name.text.trim());
                                      await _user.user!.reload();
                                      _successTrigger?.fire();
                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        if (mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const loginPage()),
                                          );
                                        }
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Hesap Oluştu Login Sayfasına Yönlediriliyorsunuz'),
                                          duration: Duration(milliseconds: 600),
                                        ),
                                      );
                                      await Future.delayed(
                                          const Duration(milliseconds: 60));
                                    } on FirebaseAuthException catch (e) {
                                      _failTrigger?.fire();
                                      String errorMessage = "Bir hata oluştu.";
                                      if (e.code == 'email-already-in-use') {
                                        errorMessage =
                                            "Bu e-posta adresi zaten kullanımda!";
                                      } else if (e.code == 'weak-password') {
                                        errorMessage = "Şifre çok zayıf.";
                                      } else if (e.code == 'invalid-email') {
                                        errorMessage =
                                            "Geçersiz e-posta formatı.";
                                      }
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(errorMessage),
                                          backgroundColor: Colors.black,
                                        ),
                                      );
                                    } catch (e) {
                                      _failTrigger?.fire();
                                      print(e);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade300),
                                child: const Text(
                                  'HESABI OLUŞTUR',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 30, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void handsOnTheEyes() {
    _isHandsUp?.change(true);
  }

  void lookOnTheField() {
    _isHandsUp?.change(false);
    _isChecking?.change(true);
    _numLook?.change(0);
  }

  void moveEyeBalls(String value) {
    _numLook?.change(value.length.toDouble());
  }
}
