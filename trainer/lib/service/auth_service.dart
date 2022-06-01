import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthService {
  Logger logger = Logger();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? user;

  AuthService() {
    _firebaseAuth.authStateChanges().listen((user) {
      logger.d("CHANGED!!");
      this.user = user;
      logger.d(user);
    }, onError: (e) {
      logger.e(e);
    });
  }

  Stream<User?> onAuthChanged() {
    logger.d("onAuthChanged");
    return _firebaseAuth.userChanges();
  }

  Future<UserCredential> signInWithGoogle() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
    // User? user = _firebaseAuth.currentUser;
    //
    // logger.d("$user");
    //
    // return user?.uid;
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<String?> getAccessToken() async {
    User? user = _firebaseAuth.currentUser;
    String? token = await user?.getIdToken();

    return token;
  }

  Future<String?> getRefreshToken() async {
    User? user = _firebaseAuth.currentUser;
    String? token = await user?.getIdToken(true);

    return token;
  }

  Future<List<void>> signOut() async {
    logger.d("signOut");

    List<Future> signedIns = [];
    if(user != null) signedIns.add(_firebaseAuth.signOut());
    if (await _googleSignIn.isSignedIn()) signedIns.add(_googleSignIn.signOut());
    return Future.wait(signedIns);
  }

  // Future signOut() async {
  //   try {
  //     logger.d('sign out complete');
  //     await _firebaseAuth.signOut();
  //     return await _googleSignIn.signOut();
  //   } catch (e) {
  //     logger.d('sign out failed');
  //     logger.d(e.toString());
  //     return null;
  //   }
  // }
}