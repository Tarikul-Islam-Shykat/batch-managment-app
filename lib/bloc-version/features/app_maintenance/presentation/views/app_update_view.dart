import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:batch_management_app_direct/bloc-version/core/widgets/app_snackbar.dart';

class AppUpdateView extends StatelessWidget {
  final String? currentVersion;
  final String? latestVersion;
  final String? updateMessage;
  final String? updateLink;
  final Map<String, String>? updateLinks;

  const AppUpdateView({
    super.key,
    this.currentVersion,
    this.latestVersion,
    this.updateMessage,
    this.updateLink,
    this.updateLinks,
  });

  String _preferredLink() {
    if (updateLink != null && updateLink!.trim().isNotEmpty) {
      return updateLink!.trim();
    }

    if (updateLinks != null && updateLinks!.isNotEmpty) {
      for (final key in const ['android_aab', 'android_arm64', 'android_x64']) {
        final val = updateLinks![key]?.trim() ?? '';
        if (val.isNotEmpty) return val;
      }
      for (final val in updateLinks!.values) {
        if (val.trim().isNotEmpty) return val.trim();
      }
    }

    return '';
  }

  Future<void> _openDownload(BuildContext context) async {
    final link = _preferredLink();
    if (link.isEmpty) {
      AppSnackbar.show(
        context: context,
        message: 'No download link available for this update.',
        isSuccess: false,
      );
      return;
    }

    final uri = Uri.tryParse(link);
    if (uri == null) {
      AppSnackbar.show(
        context: context,
        message: 'Invalid download link.',
        isSuccess: false,
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppSnackbar.show(
        context: context,
        message: 'Could not open download link.',
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = currentVersion ?? '-';
    final latest = latestVersion ?? '-';
    final message = updateMessage?.trim().isNotEmpty == true
        ? updateMessage!.trim()
        : 'A new version of the app is required to continue. Please update to enjoy the latest features and security improvements.';
    final link = _preferredLink();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              const Spacer(),

              // Update Icon
              Container(
                width: 96.w,
                height: 96.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update_alt_rounded,
                  size: 44.sp,
                  color: const Color(0xFF2563EB),
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                'Update Required',
                style: GoogleFonts.spaceGrotesk(
                  color: const Color(0xFF000710),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),

              // Message
              Text(
                message,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.black54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
              ),
              SizedBox(height: 24.h),

              // Versions Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFF),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Current Version',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black54,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          current,
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF000710),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Text(
                          'Latest Version',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black54,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF16A34A,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            latest,
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color(0xFF16A34A),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (link.isNotEmpty) ...[
                SizedBox(height: 14.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.link_rounded,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          link,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black87,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Download Button
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => _openDownload(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Download Update',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Exit App
              TextButton(
                onPressed: SystemNavigator.pop,
                child: Text(
                  'Exit Application',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.black54,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
