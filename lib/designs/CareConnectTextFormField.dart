import 'package:client/designs/CareConnectColor.dart';
import 'package:flutter/material.dart';

class CareConnectTextFormField extends StatelessWidget {
  const CareConnectTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CareConnectColor.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: CareConnectColor.neutral[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: "텍스트를 입력해주세요",
        labelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CareConnectColor.neutral[400],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}
