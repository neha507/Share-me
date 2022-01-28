import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:share_me/global.dart' as rout;
import 'package:share_me/providers/user.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 25, left: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.indigoAccent[200],
                    Colors.blue[500],
                    Colors.lightBlue,
                    Colors.lightBlueAccent,
                    Colors.lightBlueAccent[100],
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ShareMe',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico'),
                ),
                SizedBox(height: 7),
                SvgPicture.asset(
                  'images/1.svg',
                  height: 130,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.lightBlueAccent[100],
              child: Container(
                padding: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('images/globeee.jpg'),
                    colorFilter: ColorFilter.mode(
                        Color(0xff1a237e), BlendMode.colorDodge),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      UserNameWidget(),
                      SizedBox(height: 150),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                            tag: 'green',
                            child: AvatarGlow(
                              glowColor: Colors.green,
                              endRadius: 80.0,
                              duration: Duration(milliseconds: 2000),
                              repeat: true,
                              showTwoGlows: true,
                              repeatPauseDuration: Duration(milliseconds: 100),
                              child: Material(
                                elevation: 12.0,
                                shape: CircleBorder(),
                                child: FlatButton(
                                  onPressed: onClickSend,
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                            Colors.green[500],
                                            Colors.lightGreenAccent,
                                          ]),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.file_upload,
                                          color: Colors.white, size: 37),
                                      radius: 40.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AvatarGlow(
                            glowColor: Colors.blue,
                            endRadius: 80.0,
                            duration: Duration(milliseconds: 2000),
                            repeat: true,
                            showTwoGlows: true,
                            repeatPauseDuration: Duration(milliseconds: 100),
                            child: Material(
                              elevation: 12.0,
                              shape: CircleBorder(),
                              child: FlatButton(
                                onPressed: onClickReceive,
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Colors.indigoAccent[200],
                                          Colors.blue[500],
                                          Colors.lightBlue,
                                          Colors.lightBlueAccent,
                                          Colors.lightBlueAccent[100],
                                        ]),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.file_download,
                                        color: Colors.white, size: 37),
                                    radius: 40.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onClickSend() async {
    if (await _checkAndAskPermissions()) {
      rout.Router.navigator.pushNamed(rout.Router.send);
    }
  }

  void onClickReceive() async {
    if (await _checkAndAskPermissions()) {
      rout.Router.navigator.pushNamed(rout.Router.receive);
    }
  }

  /// asks for permissions if not given, returns whether or not permissions are given
  Future<bool> _checkAndAskPermissions() async {
    if (await allPermissionsGranted()) {
      return true;
    } else {
      Nearby().askLocationAndExternalStoragePermission();
    }

    return await allPermissionsGranted();
  }

  Future<bool> allPermissionsGranted() async =>
      await Nearby().checkExternalStoragePermission() &&
      await Nearby().checkLocationPermission();
}

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //edit the username onTap
        var t = TextEditingController();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: EdgeInsets.only(right: 7, bottom: 7),
              title: Text("Set username",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              content: TextField(
                controller: t,
                decoration: InputDecoration(hintText: "Username"),
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              elevation: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              actions: <Widget>[
                RawMaterialButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    rout.Router.navigator.pop(); // pop alertdialog
                  },
                ),
                MaterialButton(
                  child: Text(
                    "Set",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {
                    if (t.text.trim().isNotEmpty) {
                      rout.getP<User>().nickName = t.text.trim();
                      rout.Prefs.preferences
                          .setString(rout.Prefs.nickName, t.text.trim());
                      rout.Router.navigator.pop(); // pop alertdialog
                    }
                  },
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Consumer<User>(
              builder: (_, user, __) {
                return Text(
                  user.nickName,
                  style: TextStyle(fontSize: 30, color: Colors.black87),
                );
              },
            ),
            SizedBox(width: 17),
            Icon(
              Icons.edit,
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }
}
