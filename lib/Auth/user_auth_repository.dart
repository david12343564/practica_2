import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["email"]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isAlreadyAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> signOutGoogleUser() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOutFirebaseUser() async {
    await _auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    //Google sign in
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    print(">> User email:${googleUser.email}");
    print(">> User name:${googleUser.displayName}");
    print(">> User photo:${googleUser.photoUrl}");

    // credenciales de usuario autenticado con Google
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);

    await _createUserCollectionFirebase(_auth.currentUser!.uid);
  }

  Future<void> _createUserCollectionFirebase(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection("user").doc(uid).get();
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection("user").doc(uid).set(
        {
          "userId": "${uid}",
          "favSongs": [],
        },
      );
    } else {
      return;
    }
  }
}
