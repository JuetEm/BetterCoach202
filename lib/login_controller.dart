import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late User currentUser;

  String? email = "";
  String? url = "";
  String? name = "";

  Future<User?> googleSignIn() async {
    final GoogleSignInAccount? account;
    if(kIsWeb){
      account = await GoogleSignIn(clientId: '417922293739-s126kapoqnnpsddig5bht1dkmiclne44.apps.googleusercontent.com').signIn();
    }else{
      account = await _googleSignIn.signIn();
    }
    
    final GoogleSignInAuthentication googleAuth = await account!.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    final UserCredential userCredential = await _firebaseAuth.signInWithCredential(authCredential);
    final User? user = userCredential.user;

    currentUser = _firebaseAuth.currentUser!;

    email = user?.email;
    url = user?.photoURL;
    name = user?.displayName;

    print("email : ${email}, url : ${url}, name : ${name}");

    return user;
  }
}
