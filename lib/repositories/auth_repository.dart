import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Google login
  Future<FirebaseUser> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);
    return _auth.currentUser();
  }

  //Google logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _auth.currentUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}
