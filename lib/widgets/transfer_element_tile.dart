import 'package:flutter/material.dart';
import 'package:share_me/providers/transfer.dart';

class TransferElementTile extends StatefulWidget {
  final TransferElement element;

  TransferElementTile(this.element);

  @override
  _TransferElementTileState createState() => _TransferElementTileState();
}

class _TransferElementTileState extends State<TransferElementTile> {
  @override
  void initState() {
    widget.element.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.element.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Color(0x8fffffff),
            Color(0x8fffffff),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.element.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                    widget.element.progress == 0
                        ? Icons.check_box_outline_blank
                        : widget.element.progress < 1
                            ? Icons.indeterminate_check_box
                            : Icons.check_box,
                    color: widget.element.progress == 0
                        ? Colors.black54
                        : widget.element.progress < 1
                            ? Colors.black54
                            : Colors.greenAccent[700])
              ],
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: widget.element.progress,
              valueColor: AlwaysStoppedAnimation(Colors.blue[400]),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
