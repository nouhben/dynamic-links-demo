import 'package:deep_link_social_share/models/my_user.dart';
import 'package:deep_link_social_share/screens/signin_screen.dart';

import 'package:flutter/material.dart';

import 'home_screen.dart';

/// This widget is needed to display whether the sign_in screen
/// or the home screen depending on the auth state
/// we use provider.of with listen=false because we only want to get the auth service
/// and not to register the widget as a listener
/// then we use a streamBuilder to automatically change the ui when the status of
/// auth changes
/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Buy since we are here doesn't this means we already have a valid user?
class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key, required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<MyUser?> userSnapshot;

  @override
  Widget build(BuildContext context) {
    print('AuthWidget build ...');
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? const HomeScreen() : const SignInScreen();
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
