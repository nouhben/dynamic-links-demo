import 'package:deep_link_social_share/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('sign in'),
      ),
      body: const SafeArea(
        child: SignInForm(),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late final _formKey;
  String? _email;
  String? _password;

  void _signInWithMailAndPassword({required BuildContext context}) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final user = await auth.signInWithEmailAndPassword(
        email: _email!,
        password: _password!,
      );
      print('user: ${user!.uid}');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEmailFormField(),
                const SizedBox(height: 20.0),
                _buildPasswordFormField(),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _signInWithMailAndPassword(context: context);
                  },
                  child: const Text('Sign in'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    elevation: MaterialStateProperty.all(16.0),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _getDecoration({String? hint, String? label}) =>
      InputDecoration(
        fillColor: Colors.black,
        focusColor: Colors.black,
        floatingLabelStyle: const TextStyle(color: Colors.black),
        hintStyle: const TextStyle(color: Colors.black87),
        labelStyle: const TextStyle(color: Colors.black87),
        filled: false,
        hintText: hint,
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: const Icon(Icons.email, color: Colors.black),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 3.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 1.0),
        ),
      );
  TextFormField _buildEmailFormField() {
    return TextFormField(
      onSaved: (newValue) => setState(() => _email = newValue),
      onChanged: (value) {
        setState(() => _email = value);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Email Error";
        }
        return null;
      },
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black,
      decoration: _getDecoration(hint: 'Email'),
    );
  }

  TextFormField _buildPasswordFormField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      obscureText: true,
      onSaved: (newValue) => setState(() => _password = newValue),
      onChanged: (value) {
        setState(() => _password = value);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Password Error";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: _getDecoration(hint: 'Password'),
    );
  }
}
