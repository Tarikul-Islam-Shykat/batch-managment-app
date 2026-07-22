import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import '../const/icons_path.dart';
import 'custom_text.dart';
import 'spacing.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final String Function()? subtitleBuilder;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogo;
  final Color backgroundColor;
  final bool centerTitle;

  const AppHeaderBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleBuilder,
    this.actions,
    this.leading,
    this.showLogo = true,
    this.backgroundColor = Colors.white,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(72.h);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: centerTitle,
        automaticallyImplyLeading: leading != null,
        leading: leading,
        titleSpacing: 16.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            brandText(
              text: title,
              color: AppColors.blackColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            verticalSpace(2),
            smallText(
              text: subtitleBuilder?.call() ?? subtitle,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          if (actions != null) ...actions!,
          if (showLogo)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Center(
                child: Image.asset(
                  IconsPath.appIcon,
                  width: 34.w,
                  height: 34.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
