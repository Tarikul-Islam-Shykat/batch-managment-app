import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/global/app_btn.dart';
import '../../../core/global/custom_text.dart';
import '../../../core/global/spacing.dart';

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

  Map<String, dynamic> get _args =>
      Map<String, dynamic>.from(Get.arguments as Map? ?? {});

  String _preferredLink(Map<String, dynamic> args) {
    final directLink = args['update_link']?.toString().trim() ?? '';
    if (directLink.isNotEmpty) {
      return directLink;
    }

    final rawLinks = args['update_links'];
    if (rawLinks is Map) {
      final links = rawLinks.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );

      for (final key in const ['android_aab', 'android_arm64', 'android_x64']) {
        final value = links[key]?.trim() ?? '';
        if (value.isNotEmpty) {
          return value;
        }
      }

      for (final value in links.values) {
        final trimmed = value.trim();
        if (trimmed.isNotEmpty) {
          return trimmed;
        }
      }
    }

    return '';
  }

  Future<void> _openDownloadLink() async {
    final link = _preferredLink(_args);
    if (link.isEmpty) {
      Get.snackbar(
        'info'.tr,
        'update_link_missing'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final uri = Uri.tryParse(link);
    if (uri == null) {
      Get.snackbar(
        'failed'.tr,
        'invalid_update_link'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      Get.snackbar(
        'failed'.tr,
        'could_not_open_link'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentVersion = _args['current_version']?.toString() ?? '-';
    final latestVersion = _args['latest_version']?.toString() ?? '-';
    final updateMessage = _args['update_message']?.toString() ?? '';
    final preferredLink = _preferredLink(_args);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 92.w,
                height: 92.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update_alt_rounded,
                  size: 42.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              verticalSpace(22),
              brandText(
                text: 'update_required'.tr,
                color: AppColors.blackColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                textAlign: TextAlign.center,
              ),
              verticalSpace(8),
              normalText(
                text: updateMessage.isNotEmpty
                    ? updateMessage
                    : 'app_update_message_default'.tr,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
              verticalSpace(18),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFF),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelValueText(
                      label: '${'current_version'.tr}: ',
                      value: currentVersion,
                      labelColor: Colors.black54,
                      valueColor: AppColors.blackColor,
                    ),
                    verticalSpace(8),
                    labelValueText(
                      label: '${'latest_version'.tr}: ',
                      value: latestVersion,
                      labelColor: Colors.black54,
                      valueColor: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              if (preferredLink.isNotEmpty) ...[
                verticalSpace(14),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: labelValueText(
                    label: '${'download_update'.tr}: ',
                    value: preferredLink,
                    labelColor: Colors.black54,
                    valueColor: AppColors.blackColor,
                    maxLines: 2,
                  ),
                ),
              ],
              const Spacer(),
              GlobalAppButton(
                text: 'download_update'.tr,
                onTap: _openDownloadLink,
                height: 52.h,
                borderRadius: 12,
                backgroundColor: AppColors.primaryColor,
              ),
              verticalSpace(12),
              TextButton(
                onPressed: SystemNavigator.pop,
                child: smallText(
                  text: 'exit_app'.tr,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
