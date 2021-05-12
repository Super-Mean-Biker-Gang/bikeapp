import 'package:bikeapp/screens/accident_waver_screen.dart';
import 'package:bikeapp/screens/add_bike_screen.dart';
import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:bikeapp/screens/forgot_password.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/screens/sign_in_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/widgets/map_view.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final routes = {
    SignInScreen.routeName: (context) => SignInScreen(),
    ForgotPassword.routeName: (context) => ForgotPassword(),
    CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
    MapScreen.routeName: (context) => MapScreen(),
    AccidentWaverScreen.routeName: (context) => AccidentWaverScreen(),
    AddBikeScreen.routeName: (context) => AddBikeScreen(),
    MapView.routeName: (context) => MapView()
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: AuthenticationService(FirebaseAuth.instance).getUser())
      ],
      child: MaterialApp(
        title: 'Super Mean Biker Gang',
        theme: ThemeData(
          primaryColor: Colors.purple[600],
        ),
        debugShowCheckedModeBanner: false,
        routes: routes,
        //home: AuthenticationWrapper(),
        //home: SignInScreen(),
        home: MapView(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return MapScreen();
    }
    return SignInScreen();
  }
}
