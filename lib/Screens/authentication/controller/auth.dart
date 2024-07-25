import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_management_system/Screens/authentication/controller/response.dart';
import 'package:inventory_management_system/Screens/authentication/widgets/sign_up.dart';
import 'package:inventory_management_system/Screens/bottomBar/main_page.dart';

Future<Response<OAuthCredential>> signInWithFacebook() async {
  try {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      return Response.success(facebookAuthCredential);
    } else {
      return Response.error('Facebook login failed');
    }
  } catch (e) {
    print("Error: " + e.toString());
    return Response.error(e.toString());
  }
}

Future<Response<OAuthCredential>> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return Response.error('Google sign-in aborted');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (authResult.additionalUserInfo!.isNewUser) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SignUp(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MainPage(tab: 0),
        ),
        (route) => false,
      );
    }

    return Response.success(credential);
  } catch (e) {
    return Response.error(((e as FirebaseException).message ?? e.toString()));
  }
}
