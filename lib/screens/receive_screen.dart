import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share_me/global.dart' as rout;
import 'package:nearby_connections/nearby_connections.dart';
import 'package:share_me/providers/user.dart';
import '../payload_handler.dart';

class ReceiveScreen extends StatefulWidget {
  @override
  _ReceiveScreenState createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  bool advertising = false;

  @override
  void initState() {
    startAdvertising();
    super.initState();
  }

  @override
  void dispose() {
    Nearby().stopAdvertising();
    super.dispose();
  }

  void startAdvertising() async {
    try {
      advertising = await Nearby().startAdvertising(
        rout.getP<User>().nickName,
        Strategy.P2P_POINT_TO_POINT,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          // Called whenever a discoverer requests connection
          if (info.isIncomingConnection) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsPadding: EdgeInsets.only(right: 7, bottom: 7),
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "${info.endpointName} wants to share files",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    RawMaterialButton(
                      child: Text(
                        "Deny",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        rout.Router.navigator.pop();
                      },
                    ),
                    RawMaterialButton(
                      child: Text(
                        "Allow",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        Nearby().acceptConnection(id,
                            onPayLoadRecieved:
                                PayloadHandler().onPayloadReceived,
                            onPayloadTransferUpdate: PayloadHandler()
                                .onPayloadTransferUpdateReceiver);
                        // connection was already accepted by sender so its
                        // safe to directly go to receiver_transfer_screen
                        rout.Router.navigator
                            .pushReplacementNamed(rout.Router.receiverTransfer);
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        onConnectionResult: (String id, Status status) {
          // Called when connection is accepted/rejected
        },
        onDisconnected: (String id) {
          // Called whenever a discoverer disconnects from advertiser
        },
        serviceId: rout.serviceId,
      );
      setState(() {});
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.only(right: 7, bottom: 7),
            elevation: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Some Error occurred :(",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            content: Text(
              e.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              RawMaterialButton(
                child: Text(
                  "Go back",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
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
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  'ShareMe',
                  style: TextStyle(
                      color: Colors.lightBlueAccent[200],
                      fontSize: 44,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico'),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 466, bottom: 20),
                  child: SpinKitFadingCircle(
                    color: Colors.lightBlue,
                    size: 45,
                  )),
              Text(advertising ? "Waiting for a sender..." : "Initialising",
                  style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
