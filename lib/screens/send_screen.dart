import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:share_me/global.dart' as rout;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_me/providers/endpoints.dart';
import 'package:share_me/providers/files.dart';
import 'package:share_me/providers/user.dart';

import '../payload_handler.dart';

class SendScreen extends StatefulWidget {
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  @override
  void initState() {
    // start discovery
    startDiscovery();
    // WidgetsBinding.instance.addPostFrameCallback((_) => );
    super.initState();
  }

  @override
  void dispose() {
    // stop discovery
    Nearby().stopDiscovery();
    super.dispose();
  }

  void startDiscovery() async {
    try {
      await Nearby().startDiscovery(
          rout.getP<User>().nickName, Strategy.P2P_POINT_TO_POINT,
          onEndpointFound: (String id, String nickName, String serviceId) {
        rout.getP<Endpoints>().addUser(id, nickName);
      }, onEndpointLost: (String id) {
        rout.getP<Endpoints>().removeUser(id);
      }, serviceId: rout.serviceId);
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Some Error occurred :("),
            content: Text(e.toString()),
            actions: <Widget>[
              RaisedButton(
                child: Text("Go back"),
                onPressed: () {
                  rout.Router.navigator.pop();
                  rout.Router.navigator.pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('images/smallglobe.jpg'),
            colorFilter:
                ColorFilter.mode(Color(0xff1a237e), BlendMode.colorDodge),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    'ShareMe',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlueAccent[200],
                        fontSize: 44,
                        fontFamily: 'Pacifico'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Hero(
                tag: 'green',
                child: AvatarGlow(
                  glowColor: Colors.green,
                  endRadius: 100.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 12.0,
                    shape: CircleBorder(),
                    child: FlatButton(
                      onPressed: () async {
                        rout.getP<Files>().add(await FilePicker.getMultiFile());
                      },
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
                          child: Icon(FontAwesomeIcons.folderPlus,
                              color: Colors.white, size: 35),
                          radius: 40.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: Consumer<Files>(
                  builder: (_, files, __) {
                    return Text(
                      "${files.files.length} file(s) selected",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    );
                  },
                ),
              ),
            ),
            // RaisedButton(
            //   child: Text("Select Files"),
            //   onPressed: () async {
            //     rout.getP<Files>().add(await FilePicker.getMultiFile());
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<Files>(
        builder: (_, files, __) {
          return Padding(
            padding: EdgeInsets.all(70),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.blue[500],
                      Colors.lightBlue,
                      Colors.lightBlueAccent,
                      Colors.lightBlueAccent[100],
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25)),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                elevation: 0,
                label: Text(
                  'Send',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
                icon: Icon(Icons.send),
                onPressed: files.files.length < 1
                    ? null
                    : () {
                        //open list of advertisers to send files to..
                        showAdvertisersDialog();
                      },
              ),
            ),
          );
        },
      ),
    );
  }

  void showAdvertisersDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(
            'Available devices',
            style: TextStyle(fontSize: 23),
          )),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            width: double.maxFinite,
            child: Center(
              child: Consumer<Endpoints>(
                builder: (_, endpoints, __) {
                  if (endpoints.externalUsers.length < 1)
                    return Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: SpinKitFadingCircle(
                        color: Colors.lightBlue,
                        size: 45,
                      ),
                    );

                  return EndpointListView(endpoints);
                },
              ),
            ),
          ),
          actions: <Widget>[
            RawMaterialButton(
              elevation: 4,
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                rout.Router.navigator.pop(); // pop alertdialog
              },
            ),
          ],
        );
      },
    );
  }
}

class EndpointListView extends StatefulWidget {
  final Endpoints endpoints;
  EndpointListView(
    this.endpoints, {
    Key key,
  }) : super(key: key);

  @override
  _EndpointListViewState createState() => _EndpointListViewState();
}

class _EndpointListViewState extends State<EndpointListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.endpoints.externalUsers.length,
      itemBuilder: (_, i) {
        return Padding(
          padding: EdgeInsets.all(6),
          child: FlatButton(
            child: Text(
              "${widget.endpoints.externalUsers[i].nickName}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            onPressed: () {
              // request connection to advertiser
              requestConnection(i, context);
            },
          ),
        );
      },
    );
  }

  void requestConnection(int i, BuildContext context) {
    Nearby().requestConnection(
      rout.getP<User>().nickName,
      widget.endpoints.externalUsers[i].endpointId,
      onConnectionInitiated: (id, info) {
        if (!info.isIncomingConnection) {
          Nearby().acceptConnection(
            id,
            onPayLoadRecieved: null,
            onPayloadTransferUpdate:
                PayloadHandler().onPayloadTransferUpdateSender,
          );
        }
      },
      onConnectionResult: (id, status) {
        //send files to user..
        if (status == Status.CONNECTED) {
          rout.Router.navigator
              .pushReplacementNamed(rout.Router.senderTransfer, arguments: id);
        } else {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Connection was Rejected"),
            ),
          );
        }
      },
      onDisconnected: (id) {},
    );
  }
}
