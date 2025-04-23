import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CareConnectButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final String assetName;

  CareConnectButton({
    required this.onPressed,
    required this.text,
    this.backgroundColor = const Color.fromARGB(255, 241, 242, 243),
    this.textColor = const Color.fromARGB(255, 32, 33, 35),
    this.assetName = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (assetName.isNotEmpty)
            Container(
              margin: EdgeInsets.only(right: 6),
              child: SvgPicture.asset(
                assetName,
                color: textColor,
              ),
            ),
          Bold_20px(
            text: text,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
