import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final Function()? ontap;
  final String text;


  const MyButton({super.key, required this.ontap,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(text,style: const TextStyle(fontSize: 16,fontFamily: 'Eina',color: Colors.white),)),
        ),
      ),
    );
  }

}