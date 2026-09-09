import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/locale/locale_cubit.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';

/// Settings screen — reachable by every role. Holds the language
/// switcher plus links to About / Privacy / Terms, and a duplicate
/// logout entry point (the header's avatar menu also has one).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.subtitleSettings),
      // Admin and surgeon reach Settings via its own bottom-nav tab, so
      // this screen must render inside the same shell to keep the bar
      // visible — coordinator has no Settings tab (see
      // AppBottomNavBar's doc comment) and reaches this screen by
      // pushing from the Manage hub instead, so it renders without a
      // bottom bar for that role, same as any other pushed sub-screen.
      bottomNavigationBar: user == null
          ? null
          : AppBottomNavBar(role: user.role, currentRouteName: AppRoutes.settings),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          children: [
            Text(l10n.settingsTitle, style: AppTextStyles.headlineMd),
            const SizedBox(height: AppSpacing.md),
            _LanguageCard(l10n: l10n),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _NavRow(
                    icon: Icons.info_outline,
                    label: l10n.settingsAbout,
                    onTap: () =>
                        context.pushNamed(AppRoutes.settingsAbout),
                  ),
                  const Divider(height: 1),
                  _NavRow(
                    icon: Icons.privacy_tip_outlined,
                    label: l10n.settingsPrivacyPolicy,
                    onTap: () =>
                        context.pushNamed(AppRoutes.settingsPrivacy),
                  ),
                  const Divider(height: 1),
                  _NavRow(
                    icon: Icons.description_outlined,
                    label: l10n.settingsTermsConditions,
                    onTap: () =>
                        context.pushNamed(AppRoutes.settingsTerms),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              padding: EdgeInsets.zero,
              child: _NavRow(
                icon: Icons.logout,
                label: l10n.settingsLogout,
                color: AppColors.danger,
                onTap: () =>
                    context.read<AuthBloc>().add(const AuthLogoutRequested()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final current = context.watch<LocaleCubit>().state.languageCode;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settingsLanguageSection, style: AppTextStyles.labelLg),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _LanguageOption(
                  label: l10n.settingsLanguageEnglish,
                  selected: current == 'en',
                  onTap: () => context
                      .read<LocaleCubit>()
                      .setLocale(const Locale('en')),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _LanguageOption(
                  label: l10n.settingsLanguageArabic,
                  selected: current == 'ar',
                  onTap: () => context
                      .read<LocaleCubit>()
                      .setLocale(const Locale('ar')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.statusFreeBg : AppColors.background,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.divider,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelLg.copyWith(color: color),
              ),
            ),
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              size: 20,
              color: color ?? AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
