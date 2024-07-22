import 'package:flutter/material.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/utils/const/widgets.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function onClick;
  final String text;
  final Color? color;
  final double? height;
  final double? width;
final double? radius;

  const CustomElevatedButton({super.key,required this.onClick,required this.text,this.color,this.height,this.width,this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width:width?? screenWidth*0.6,
      child: ElevatedButton(
          onPressed: ()=>onClick(),
          style: ElevatedButton.styleFrom(
            backgroundColor:color ?? Constants.primaryColor ,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 10)
            )
          ),
          child: Text(text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
          )
      ),
    );
  }
}
