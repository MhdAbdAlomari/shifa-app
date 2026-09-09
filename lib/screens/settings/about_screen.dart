import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_card.dart';

const _developerEmail = 'mohamed.alomari.dev@gmail.com';
const _developerPhone = '+963964360686';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String? _version;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _version = info.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textOnPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.aboutAppName, style: AppTextStyles.headlineMd),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.aboutDescription, style: AppTextStyles.bodyMd),
            const SizedBox(height: AppSpacing.sm),
            if (_version != null)
              Text(
                l10n.aboutVersion(_version!),
                style: AppTextStyles.bodySm,
              ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aboutDeveloperSection,
                    style: AppTextStyles.labelLg,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(l10n.aboutDeveloperName, style: AppTextStyles.titleLg),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.aboutDeveloperBlurb,
                    style: AppTextStyles.bodySm,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ContactRow(
                    icon: Icons.email_outlined,
                    text: _developerEmail,
                    onTap: () => launchUrl(
                      Uri(scheme: 'mailto', path: _developerEmail),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _ContactRow(
                    icon: Icons.call_outlined,
                    text: _developerPhone,
                    onTap: () => launchUrl(
                      Uri(scheme: 'tel', path: _developerPhone),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
