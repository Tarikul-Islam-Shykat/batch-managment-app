import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:batch_management_app_direct/bloc-version/core/localization/localization_extension.dart';
import '../../data/models/profile_model.dart';

class ProfileEditSheet extends StatefulWidget {
  final UserProfileModel user;
  final Future<void> Function(Map<String, dynamic> payload) onSave;

  const ProfileEditSheet({super.key, required this.user, required this.onSave});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController institutionNameController;
  late final TextEditingController teachingLevelController;
  late final TextEditingController institutionLocationController;
  late final TextEditingController bioController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    institutionNameController = TextEditingController(
      text: widget.user.institutionName == '-'
          ? ''
          : widget.user.institutionName,
    );
    teachingLevelController = TextEditingController(
      text: widget.user.teachingLevel == '-' ? '' : widget.user.teachingLevel,
    );
    institutionLocationController = TextEditingController(
      text: widget.user.institutionLocation == '-'
          ? ''
          : widget.user.institutionLocation,
    );
    bioController = TextEditingController(
      text: widget.user.bio == '-' ? '' : widget.user.bio,
    );
  }

  @override
  void dispose() {
    institutionNameController.dispose();
    teachingLevelController.dispose();
    institutionLocationController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000710),
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14.sp,
            color: const Color(0xFF000710),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.spaceGrotesk(
              fontSize: 14.sp,
              color: const Color(0xFF898989),
            ),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 14.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final payload = <String, dynamic>{};

    void addIfChanged(String key, String current, String original) {
      final currentText = current.trim();
      final originalText = original.trim();
      if (currentText != originalText && currentText.isNotEmpty) {
        payload[key] = currentText;
      }
    }

    addIfChanged(
      'institution_name',
      institutionNameController.text,
      widget.user.institutionName == '-' ? '' : widget.user.institutionName,
    );
    addIfChanged(
      'teaching_level',
      teachingLevelController.text,
      widget.user.teachingLevel == '-' ? '' : widget.user.teachingLevel,
    );
    addIfChanged(
      'institution_location',
      institutionLocationController.text,
      widget.user.institutionLocation == '-'
          ? ''
          : widget.user.institutionLocation,
    );
    addIfChanged(
      'bio',
      bioController.text,
      widget.user.bio == '-' ? '' : widget.user.bio,
    );

    if (payload.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => isSaving = true);
    try {
      await widget.onSave(payload);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  context.tr('edit_profile'),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000710),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.user.name.isNotEmpty
                      ? widget.user.name
                      : widget.user.email,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildField(
                  controller: institutionNameController,
                  labelText: context.tr('institution_name'),
                  hintText: context.tr('institution_name'),
                ),
                SizedBox(height: 12.h),
                _buildField(
                  controller: teachingLevelController,
                  labelText: context.tr('teaching_level'),
                  hintText: context.tr('teaching_level'),
                ),
                SizedBox(height: 12.h),
                _buildField(
                  controller: institutionLocationController,
                  labelText: context.tr('institution_location'),
                  hintText: context.tr('institution_location'),
                ),
                SizedBox(height: 12.h),
                _buildField(
                  controller: bioController,
                  labelText: context.tr('bio'),
                  hintText: context.tr('bio'),
                  maxLines: 4,
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: isSaving
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            context.tr('save_changes'),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
