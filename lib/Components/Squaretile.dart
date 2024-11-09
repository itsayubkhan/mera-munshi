import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget{
  final ImagePath;
  final double height;
  final Function()? ontap;

  const SquareTile({super.key, required this.ImagePath,required this.height,required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200]
        ),
        child: Image.asset(ImagePath,height: height,),
      ),
    );
  }

}