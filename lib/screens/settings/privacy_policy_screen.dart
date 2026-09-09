import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/policy_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lastUpdated = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    ).format(DateTime(2026, 9, 9));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          children: [
            Text(
              l10n.privacyLastUpdated(lastUpdated),
              style: AppTextStyles.bodySm,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.privacyIntro, style: AppTextStyles.bodyMd),
            const SizedBox(height: AppSpacing.lg),
            PolicySection(
              heading: l10n.privacyCollectedHeading,
              body: l10n.privacyCollectedBody,
            ),
            PolicySection(
              heading: l10n.privacyUsageHeading,
              body: l10n.privacyUsageBody,
            ),
            PolicySection(
              heading: l10n.privacySharingHeading,
              body: l10n.privacySharingBody,
            ),
            PolicySection(
              heading: l10n.privacyStorageHeading,
              body: l10n.privacyStorageBody,
            ),
            PolicySection(
              heading: l10n.privacyContactHeading,
              body: l10n.privacyContactBody,
            ),
          ],
        ),
      ),
    );
  }
}
