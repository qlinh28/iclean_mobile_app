import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/utils/color_palette.dart';

class UpdateTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text, hintText;
  final String? Function(dynamic value)? validator;

  const UpdateTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator, required this.text,
  });

  @override
  State<UpdateTextField> createState() => _UpdateTextField();
}

class _UpdateTextField extends State<UpdateTextField> {
  late FocusNode focusNode;
  Color backgroundColor = ColorPalette.textFieldColorLight;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        if (focusNode.hasFocus) {
          backgroundColor = ColorPalette
              .textFieldColorFocused; // Change to the desired focused color
        } else {
          backgroundColor = ColorPalette
              .textFieldColorLight; // Revert to default color when not focused
        }
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: focusNode, // Attach the FocusNode
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: ColorPalette.greyColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          borderSide: BorderSide(
            color: ColorPalette.mainColor,
          ),
        ),
        fillColor: backgroundColor,
        filled: true,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: ColorPalette.greyColor,
          fontFamily: 'Lato',
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Lato',
      ),
      cursorColor: Colors.black,
    );
  }
}
