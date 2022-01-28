import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_me/providers/endpoints.dart';
import 'package:share_me/providers/files.dart';
import 'package:share_me/providers/transfer.dart';
import 'package:share_me/providers/user.dart';
import 'package:share_me/global.dart' as rout;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: User(""),
        ),
        ChangeNotifierProvider.value(
          value: Endpoints(),
        ),
        ChangeNotifierProvider.value(
          value: Files(),
        ),
        ChangeNotifierProvider.value(
          value: Transfer(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nearby Sharer',
        theme: ThemeData.light(),
        navigatorKey: rout.Router.navKey,
        initialRoute: rout.Router.splash,
        onGenerateRoute: rout.Router.routes,
      ),
    );
  }
}
