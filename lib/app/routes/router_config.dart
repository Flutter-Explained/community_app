import 'package:community_app/counter/view/counter_page.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show ActionCodeSettings, FirebaseAuth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final providers = <AuthProvider>[
  EmailAuthProvider(),
  EmailLinkAuthProvider(
    actionCodeSettings: ActionCodeSettings(
      url: 'http://localhost',
      handleCodeInApp: true,
      androidMinimumVersion: '1',
      androidPackageName: 'dev.flutterexplained.community_app.dev',
      iOSBundleId: 'dev.flutterexplained.community_app.dev',
    ),
  ),
];

final GoRouter routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return FirebaseAuth.instance.currentUser != null
            ? const CounterPage()
            : SignInScreen(
                providers: providers,
                actions: [
                  EmailLinkSignInAction((context) {
                    context.go('/email-link-sign-in');
                  })
                ],
              );
      },
    ),
    GoRoute(
      path: '/sign-in',
      builder: (BuildContext context, GoRouterState state) {
        return SignInScreen(
          providers: providers,
          actions: [
            EmailLinkSignInAction((context) {
              context.go('/email-link-sign-in');
            }),
            AuthStateChangeAction((context, state) {
              context.go('/profile');
            })
          ],
        );
      },
    ),
    GoRoute(
      path: '/email-link-sign-in',
      builder: (context, state) => EmailLinkSignInScreen(
        actions: [
          AuthStateChangeAction((context, state) {
            context.go('/profile');
          }),
        ],
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return ProfileScreen(
          providers: providers,
          actions: [
            SignedOutAction((context) {
              context.go('/sign-in');
            })
          ],
        );
      },
    )
  ],
);
