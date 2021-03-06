import 'package:flutter/material.dart';

import 'package:admu_student_app/constants/app_colors.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // icon
          SizedOverflowBox(
            size: Size(32, 22),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 29, // ?
              color: AppColors.GRAY_LIGHT[2],
            ),
          ),
          SizedBox(width: 12),

          // text
          Expanded(
            child: Text(text,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.GRAY_LIGHT[2])),
          ),
          SizedBox(width: 4), // temporary padding

          // close button
          /*IconButton(
            iconSize: 22, // 22?
            icon: Icon(Icons.close_rounded),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            color: AppColors.GRAY_LIGHT[2],
          ),*/
        ],
      ),
      backgroundColor: AppColors.SECONDARY_MAIN,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.fromLTRB(32, 0, 24, 0), // original 10 vertical
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
