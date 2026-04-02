import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panda_login/pages/signup_page.dart';
import 'package:rive/rive.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginState();
}

class _loginState extends State<loginPage> {
  late String _animationURL;
  Artboard? _teddyArtboard;
  SMITrigger? _successTrigger, _failTrigger;
  SMIBool? _isHandsUp, _isChecking;
  SMINumber? _numLook;
  StateMachineController? _stateMachineController;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isObscure = true;
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
    _stateMachineController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd6e2ea),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
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
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                            const SizedBox(height: 40),
                            const Text(
                              'HOŞ GELDİNİZ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _email,
                              validator: (value) => value!.contains('@')
                                  ? null
                                  : 'Lütfen Emaili Giriniz',
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
                              onTap: handsOnTheEyes,
                              validator: (value) => value!.isEmpty
                                  ? 'Lütfen Şifreyi Giriniz'
                                  : null,
                              onFieldSubmitted: (value) {
                                login();
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
                                filled: true,
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
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  _resetPassword(context);
                                },
                                child: const Text(
                                  'Şifremi Unuttum   ',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade300),
                              child: const Text(
                                'GİRİŞ YAP',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _isChecking?.change(false);
                                _isHandsUp?.change(false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const signupPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'HESABIN YOK MU? HESAP OLUŞTUR',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
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

  Future<void> login() async {
    _isChecking?.change(false);
    _isHandsUp?.change(false);
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential _user = await _firebaseAuth.signInWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim());
        _successTrigger?.fire();
        print(_user.user.toString());
      } catch (e) {
        print(e.toString());
        _failTrigger?.fire();
      }
    } else {
      _failTrigger?.fire();
    }
  }
}

Future<void> _resetPassword(dynamic context) async {
  final TextEditingController _resetemail = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Şifre Sıfırlama'),
      content: Form(
        key: _formkey,
        child: TextFormField(
          controller: _resetemail,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email Adresini Giriniz',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Email Boş Olamaz';
            }
            if (value.contains('@')) {
              return 'Geçerli Bir Email Giriniz';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              try {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _resetemail.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Şifre Sıfırlama Emaili Gönderildi')));
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          },
          child: const Text('Gönder',style: TextStyle(color: Colors.black),),
        ),
      ],
    ),
  );
}
