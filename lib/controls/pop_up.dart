import 'package:dvt/controls/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<dynamic> popupControl({
  required BuildContext context,
  required String message,
  required String title,
  GestureTapCallback? onConfirm,
}) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
           
            TextControl(
              text: title,
              size: TextProps.md,
              isBold: true,
            )
          ],
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.all(20),
        actionsPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextControl(
              text: message,
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: TextControl(
                        text: 'Yes',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: TextControl(
                        text: 'No',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
