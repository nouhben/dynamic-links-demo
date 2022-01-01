import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/auth_wdiget_builder.dart';
import 'screens/auth_widget.dart';
import 'services/dynamic_links_service.dart';
import 'services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create: (context) => FirebaseAuthService(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: MaterialApp(
          title: 'Flutter Dynamic Linking Demo',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const InitialWidget(),
        ),
      ),
    );
  }
}

class InitialWidget extends StatefulWidget {
  const InitialWidget({
    Key? key,
  }) : super(key: key);
  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  late DynamicLinkService _service;
  bool isOpenedFromDynamicLink = false;

  @override
  void initState() {
    super.initState();
    _service = DynamicLinkService();
    Future.delayed(const Duration(milliseconds: 1)).then(
      (value) => handle(),
    );
  }

  Future<void> handle() async {
    await _service.handle(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthWidgetBuilder(
      builder: (context, snapshot) => AuthWidget(userSnapshot: snapshot),
    );
  }
}
