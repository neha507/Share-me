import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:share_me/providers/transfer.dart';
import 'package:share_me/widgets/transfer_element_tile.dart';

import '../global.dart';

class ReceiverTransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Transfer>(
      builder: (_, transfer, __) {
        if (transfer.transferElements.length < 1) {
          return Center(
            child: SpinKitFadingCircle(
              color: Colors.lightBlue,
              size: 45,
            ),
          );
        } else {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/b10.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              constraints: BoxConstraints.expand(),
              child: SafeArea(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 2, right: 2, top: 23, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Received files',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'MyFont',
                        ),
                      ),
                      SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: getP<Transfer>().transferElements.length,
                            itemBuilder: (context, i) {
                              return TransferElementTile(
                                  getP<Transfer>().transferElements[i]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
