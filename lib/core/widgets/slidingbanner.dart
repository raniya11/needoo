import 'package:flutter/material.dart';
import 'package:food_delivery_app/Apptext.dart';

class sliding_banner extends StatelessWidget {
  const sliding_banner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      height: size.height*0.016,
      width: size.width*0.036,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/img/Chicken_Nuggets.jpg"),
            fit: BoxFit.cover),
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Align(
              alignment: Alignment(-0.8, -0.6),
              child: AppText(
                text:
                "Wrap up your cravings\nwith our sizzling\nshawarmas!",
                color: Colors.white,
                fw: FontWeight.w500,
                size: 16,
              )),
          Align(
            alignment: Alignment(-0.85, 0.75),
            child: Container(
              height: size.height*0.035,
              width: size.width*0.25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: AppText(
                  text: "Order now",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
