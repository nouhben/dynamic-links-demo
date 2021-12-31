import 'package:deep_link_social_share/models/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class FirebaseAuthService extends AuthService<MyUser> {
  final _firebaseAuth = FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(User? firebaseUser) =>
      firebaseUser == null ? null : MyUser(uid: firebaseUser.uid);
  @override
  Stream<MyUser?> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();

  @override
  Future<MyUser?> signInAnon() async {
    final result = await _firebaseAuth.signInAnonymously();
    return _userFromFirebaseUser(result.user);
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebaseUser(result.user);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<void> sendRestPasswordEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<MyUser?> signInWithApple() async {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebaseUser(result.user);
  }

  @override
  Future<MyUser?> signInWithFacebook() async {
    throw UnimplementedError();
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  MyUser? get currentUser => _userFromFirebaseUser(_firebaseAuth.currentUser);
}
