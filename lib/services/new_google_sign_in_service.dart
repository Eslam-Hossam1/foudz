// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// // Google Sign-In Service Class
// class GoogleSignInService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//   static bool isInitialize = false;
//   static Future<void> initSignIn() async {
//     if (!isInitialize) {
//       await _googleSignIn.initialize(
//         serverClientId:
//             '484988555302-d91nev5jn5sit0qoe3oehpgpp58pl5mt.apps.googleusercontent.com',
//       );
//     }
//     isInitialize = true;
//   }

//   // Sign in with Google
//   static Future<UserCredential?> signInWithGoogle() async {
//     try {
//       initSignIn();
//       final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
//       final idToken = googleUser.authentication.idToken;
//       final authorizationClient = googleUser.authorizationClient;
//       GoogleSignInClientAuthorization? authorization = await authorizationClient
//           .authorizationForScopes(['email', 'profile']);
//       final accessToken = authorization?.accessToken;
//       if (accessToken == null) {
//         final authorization2 = await authorizationClient.authorizationForScopes(
//           ['email', 'profile'],
//         );
//         if (authorization2?.accessToken == null) {
//           //  throw FirebaseAuthException(code: "error", message: "error");
//           log('google sign in failed');
//         }
//         authorization = authorization2;
//       }
//       final credential = GoogleAuthProvider.credential(
//         accessToken: accessToken,
//         idToken: idToken,
//       );
//       final UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithCredential(credential);

//       try {
//           final apiResponse = await model.authRequest.socialLogin(
//             googleUser.email,
//             googleAuth.idToken,
//             "google",
//           );
//           //
//           if (apiResponse != null) {
//             await model.handleDeviceLogin(apiResponse);
//           } else {
//             model.openRegister(
//               email: googleUser.email,
//               name: googleUser.displayName,
//             );
//           }
//         } catch (error) {
//           model.toastError("$error");
//         }
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }

//   // Sign out
//   static Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//     } catch (e) {
//       print('Error signing out: $e');
//       throw e;
//     }
//   }

//   // Get current user
//   static User? getCurrentUser() {
//     return _auth.currentUser;
//   }
// }
