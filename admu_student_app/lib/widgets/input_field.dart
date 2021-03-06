import 'package:flutter/material.dart';

import 'package:admu_student_app/constants/app_colors.dart';

class InputField extends StatefulWidget {
  InputField({
    Key key,
    this.isMultiLined,
    this.length,
    @required this.controller,
    this.hint = '',
  }) : super(key: key);

  final bool isMultiLined;
  final int length;
  final TextEditingController controller;
  final String hint;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.GRAY_LIGHT[2],
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.multiline, //expands when make lagpas
        maxLines: widget.isMultiLined == true ? null : 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          hintText: widget.hint,
          hintStyle: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: AppColors.GRAY_DARK[2]),
          counterText: "", //Disables maxLength showing in Field
        ),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: AppColors.GRAY_DARK[0]),
        maxLength: widget.length,
      ),
    );
  }
}
