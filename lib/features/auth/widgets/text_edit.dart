import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/constant/app_colors.dart';
import '../../shared_widgets/custom_text.dart';

class TextEdit extends StatefulWidget {
  const TextEdit({
    super.key,
    required this.lable,
    required this.controller,
    this.icon,
    this.isPassword = false,
    this.fontSize
  });

  final String lable;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPassword;
  final double? fontSize;

  @override
  State<TextEdit> createState() => _TextEditState();
}

class _TextEditState extends State<TextEdit> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(widget.fontSize != null ? 8.h :  4.h),
        CustomText(text: widget.lable, size:widget.fontSize ??  12),
        Gap(widget.fontSize != null ? 16.h :  4.h),
        TextFormField(
          controller: widget.controller,
            obscureText: _obscureText,
            textInputAction:
            widget.isPassword ? TextInputAction.done : TextInputAction.next,
            cursorColor: AppColors.primary,
          style: TextStyle(
            fontSize:  15.sp,
            fontFamily: 'Cairo',
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: "${'enter_text'.tr()} ${widget.lable}",
            hintStyle: TextStyle(
              fontSize:13.sp,
              color: const Color(0xff76777D),
              fontFamily: 'Cairo',
            ),

            prefixIcon:
            widget.icon != null ? Icon(widget.icon) : null,

            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,

            filled: true,
            fillColor: Colors.white,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xffD9D9D9),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Color(0xffD9D9D9),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${widget.lable} ${'required_text'.tr()}';
              }
              return null;
            }
        ),
      ],
    );
  }
}