import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebaseauth_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text(
                  'Create an account',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validateEmail,
                  onSaved: con.saveEmail,
                ),
                SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                  ),
                  autocorrect: false,
                  obscureText: true,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                  ),
                  autocorrect: false,
                  obscureText: true,
                  validator: con.validatePassword,
                  onSaved: con.saveConfirmPassword,
                ),
                ElevatedButton(
                  onPressed: con.signUp,
                  child: Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _SignUpState state;
  _Controller(this.state);

  String? email;
  String? password;
  String? passwordConfirm;

  void signUp() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();

    if (password != passwordConfirm) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'password and confirm do not match',
        seconds: 15,
      );
      return;
    }

    User? user;
    MyDialog.circularProgressStart(state.context);
    try {
      await FirebaseAuthController.createAccount(
        email: email!,
        password: password!,
      );
      // get default username from email
      String defaultUsername = email!.split('@')[0];
      user = await FirebaseAuthController.signIn(
        email: email!,
        password: password!,
      );
      // assign default username to user
      if (user != null) {
        await FirebaseAuthController.updateDisplayName(
          displayName: defaultUsername,
          user: user,
        );
      }
      await FirebaseAuthController.signOut();
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Account created! Sign in to use the app.',
      );
      MyDialog.circularProgressStop(state.context);
      Navigator.of(state.context).pop(); // pop from Sign Up Screen
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('========== create account error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Cannot create account: $e',
      );
    }
  }

  String? validateEmail(String? value) {
    if (value == null || !(value.contains('.') && value.contains('@')))
      return 'Invalid email address';
    else
      return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6)
      return 'password too short';
    else
      return null;
  }

  void saveEmail(String? value) {
    email = value;
  }

  void savePassword(String? value) {
    password = value;
  }

  void saveConfirmPassword(String? value) {
    passwordConfirm = value;
  }
}
