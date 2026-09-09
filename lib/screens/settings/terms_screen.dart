import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import 'widgets/policy_section.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lastUpdated = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    ).format(DateTime(2026, 9, 9));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.termsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          children: [
            Text(
              l10n.termsLastUpdated(lastUpdated),
              style: AppTextStyles.bodySm,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.termsIntro, style: AppTextStyles.bodyMd),
            const SizedBox(height: AppSpacing.lg),
            PolicySection(
              heading: l10n.termsAuthorizedHeading,
              body: l10n.termsAuthorizedBody,
            ),
            PolicySection(
              heading: l10n.termsAccuracyHeading,
              body: l10n.termsAccuracyBody,
            ),
            PolicySection(
              heading: l10n.termsDecisionSupportHeading,
              body: l10n.termsDecisionSupportBody,
            ),
            PolicySection(
              heading: l10n.termsAccountsHeading,
              body: l10n.termsAccountsBody,
            ),
            PolicySection(
              heading: l10n.termsContactHeading,
              body: l10n.termsContactBody,
            ),
          ],
        ),
      ),
    );
  }
}
