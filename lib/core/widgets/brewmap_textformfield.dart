import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';

class BrewmapTextFormfield extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final bool obscureText;

  const BrewmapTextFormfield({
    super.key,
    required this.validator,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  State<BrewmapTextFormfield> createState() => _BrewmapTextFormfieldState();
}

class _BrewmapTextFormfieldState extends State<BrewmapTextFormfield> {
  bool isShownPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SizeConstants.s24,
        vertical: SizeConstants.s12,
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        obscureText: isShownPassword ? false : widget.obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(SizeConstants.s12),
          ),
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isShownPassword = !isShownPassword;
                    });
                  },
                  icon: isShownPassword
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                )
              : null,
        ),
      ),
    );
  }
}
