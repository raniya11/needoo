
import 'package:flutter/material.dart';

class Category_container extends StatelessWidget {
  const Category_container({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height*0.12,
      width: size.width*0.26,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/img/burger.png"),
            fit: BoxFit.cover),
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}