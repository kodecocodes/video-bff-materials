import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import 'activities_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providerConfigs: [
                const EmailProviderConfiguration(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset('assets/running.png'),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to Activities App! Sign in to continue.'
                        : 'Welcome to Activities App! Create an account ' +
                            'to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'Powered by you!',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            );
          }
          return const ActivitiesScreen();
        });
  }
}
