import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// A single heading + body block, used by the Privacy Policy and Terms
/// & Conditions screens — both are static, section-structured legal
/// text with an identical layout.
class PolicySection extends StatelessWidget {
  const PolicySection({super.key, required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: AppTextStyles.titleLg),
          const SizedBox(height: AppSpacing.xxs),
          Text(body, style: AppTextStyles.bodyMd),
        ],
      ),
    );
  }
}
