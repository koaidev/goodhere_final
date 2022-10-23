// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sixam_mart/view/screens/splash/splash_screen.dart';
//
// class AuthGate extends StatelessWidget {
//   const AuthGate({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     PhoneAuthProvider();
//
//     return StreamBuilder<User>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // User is not signed in
//         if (!snapshot.hasData) {
//           return SplashScreen(
//               providerConfigs: []
//           );
//         }
//
//         // Render your application if authenticated
//         return YourApplication();
//       },
//     );
//   }
// }