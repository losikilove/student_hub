import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget{
  const CustomDivider({super.key});
  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: Divider(
        height: 20,
        thickness: 2,
        indent: 40,
        endIndent: 35,
        color: Colors.black,          

      ),
      
    );
  }
}