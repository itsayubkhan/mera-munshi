import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool obscureText;
  final EdgeInsetsGeometry padding;
  final onchanged;
  final maxlines;

  const MyTextField({super.key, 
    this.onchanged,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.padding = const EdgeInsets.all(0),
    this.maxlines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        maxLines: maxlines,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        obscureText: obscureText,
        controller: controller,
        onChanged: onchanged,
        style: TextStyle(fontFamily: 'Eina',color: Colors.grey[700]),
        decoration: InputDecoration(
          labelStyle: TextStyle(fontFamily: 'Eina',color: Colors.grey[500]),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          hintText: hintText,
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(fontFamily: 'Eina',color: Colors.grey[500])
        ),
      ),
    );
  }
}
