import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/history_entry_model.dart';

class HistoryCard extends StatelessWidget {
  final HistoryEntryModel entry;

  const HistoryCard({super.key, required this.entry});

  Color _badgeColor() {
    final action = entry.action.toLowerCase();
    if (action.contains('delete')) return const Color(0xFFEF4444);
    if (action.contains('create')) return const Color(0xFF16A34A);
    if (action.contains('update') || action.contains('edit')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF2563EB);
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = _badgeColor();
    final details = entry.details.entries.toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action Badge & Timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  entry.action.isNotEmpty
                      ? entry.action.toUpperCase()
                      : 'HISTORY',
                  style: GoogleFonts.spaceGrotesk(
                    color: badgeColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (entry.formattedTime.isNotEmpty)
                Text(
                  entry.formattedTime,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.black45,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
            ],
          ),
          SizedBox(height: 12.h),

          // Title
          Text(
            entry.title,
            style: GoogleFonts.spaceGrotesk(
              color: const Color(0xFF000710),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Description
          if (entry.description.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              entry.description,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.black54,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Details Chips
          if (details.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: details.take(6).map((item) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${item.key}: ',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black54,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: item.value.toString(),
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF000710),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Actor Information Row
          if (entry.actorName.isNotEmpty || entry.actorRole.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (entry.actorName.isNotEmpty)
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Actor: ',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.black54,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: entry.actorName,
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color(0xFF000710),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (entry.actorRole.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      entry.actorRole,
                      style: GoogleFonts.spaceGrotesk(
                        color: badgeColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
