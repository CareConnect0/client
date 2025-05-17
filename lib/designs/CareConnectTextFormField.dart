import 'package:client/api/Assistant/assistant_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CareConnectTextFormField extends ConsumerStatefulWidget {
  final bool isAI;
  const CareConnectTextFormField({super.key, this.isAI = false});

  @override
  ConsumerState<CareConnectTextFormField> createState() =>
      _CareConnectTextFormFieldState();
}

class _CareConnectTextFormFieldState
    extends ConsumerState<CareConnectTextFormField> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CareConnectColor.black),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: CareConnectColor.neutral[100],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
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
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {
              if (widget.isAI) {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  final viewModel =
                      ref.read(assistantViewModelProvider.notifier);
                  viewModel.sendMessage(text);
                  _controller.clear(); // 입력창 초기화
                }
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: CareConnectColor.neutral[600],
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/icons/arrow-narrow-right.svg",
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
