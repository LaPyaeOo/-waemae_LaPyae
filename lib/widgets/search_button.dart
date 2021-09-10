import 'package:flutter/material.dart';
import 'package:waemaeskeleton/constants/colors.dart';

class SearchButton extends StatelessWidget {
  SearchButton({required this.onPress});
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      width: 231.0,
      height: 39.0,
      decoration: BoxDecoration(
          gradient: ButtonGradientColor,
          borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: RawMaterialButton(
          onPressed: onPress,
          child: Text(
            'Filter Search'.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

