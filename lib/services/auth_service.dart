abstract class AuthService<T> {
  //Future<T?> currentUser();
  Future<T?> signInAnon();
  Future<T?> signInWithEmailAndPassword({
    required final String email,
    required final String password,
  });
  Future<T?> createUserWithEmailAndPassword({
    required final String email,
    required final String password,
  });
  Future<void> sendRestPasswordEmail({required final String email});
  Future<T?> signInWithGoogle();
  Future<T?> signInWithApple();
  Future<T?> signInWithFacebook();
  Future<void> signOut();
  void dispose();
  Stream<T?> get onAuthStateChanged;
}
