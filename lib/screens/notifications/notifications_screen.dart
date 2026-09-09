import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/notifications/notifications_bloc.dart';
import '../../blocs/unread_notifications/unread_notifications_cubit.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/app_notification.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc(
        service: context.read<AppContainer>().notificationService,
      )..add(const NotificationsRequested()),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.subtitleClinicalAlerts),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.notifications,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          // Refresh the header's unread cubit whenever this screen's
          // items list changes — keeps the bell in sync with the inbox.
          listenWhen: (p, c) => p.items != c.items,
          listener: (context, state) {
            context
                .read<UnreadNotificationsCubit>()
                .setCount(state.unreadCount);
          },
          builder: (context, state) {
            return switch (state.status) {
              NotificationsStatus.initial ||
              NotificationsStatus.loading =>
                state.items.isEmpty ? const LoadingView() : _Body(state: state),
              NotificationsStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback:
                        state.errorMessage ?? l10n.notificationsFailedToLoad,
                  ),
                  onRetry: () => context
                      .read<NotificationsBloc>()
                      .add(const NotificationsRequested()),
                ),
              NotificationsStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final NotificationsState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => context
          .read<NotificationsBloc>()
          .add(const NotificationsRefreshRequested()),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              AppSpacing.md,
              AppSpacing.screenEdge,
              AppSpacing.xs,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(l10n.notificationsTitle, style: AppTextStyles.headlineMd),
                  const SizedBox(width: AppSpacing.xs),
                  if (state.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.statusFreeBg,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                        border: Border.all(
                          color: AppColors.statusFreeBorder,
                        ),
                      ),
                      child: Text(
                        l10n.notificationsNewCount(state.unreadCount),
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (state.unreadCount > 0)
                    TextButton(
                      onPressed: () => context
                          .read<NotificationsBloc>()
                          .add(const NotificationsMarkAllReadRequested()),
                      child: Text(
                        l10n.notificationsMarkAllRead,
                        style: AppTextStyles.labelLg.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (state.items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyView(
                icon: Icons.notifications_none,
                title: l10n.notificationsNoneTitle,
                subtitle: l10n.notificationsNoneSubtitle,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenEdge,
              ),
              sliver: SliverList.separated(
                itemCount: state.items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (context, i) =>
                    _NotificationRow(item: state.items[i]),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final AppNotification item;

  String _relative(BuildContext context, DateTime when) {
    final l10n = AppLocalizations.of(context);
    final delta = DateTime.now().difference(when.toLocal()).inSeconds;
    if (delta < 60) return l10n.notificationsJustNow;
    if (delta < 3600) return l10n.notificationsMinutesAgo((delta / 60).floor());
    if (delta < 86400) return l10n.notificationsHoursAgo((delta / 3600).floor());
    if (delta < 604800) return l10n.notificationsDaysAgo((delta / 86400).floor());
    return DateFormat('MMM d').format(when.toLocal());
  }

  (IconData, Color) _iconFor(AppNotification n) {
    // The API type is a free string; we only observe `schedule_suggestion`
    // in the doc but tolerate anything and fall back to a neutral icon.
    switch (n.type) {
      case 'schedule_suggestion':
        return (Icons.event, AppColors.secondary);
      case 'delay':
        return (Icons.warning_amber_outlined, AppColors.accentText);
      case 'completed':
        return (Icons.check_circle_outline, AppColors.primary);
      default:
        return (Icons.notifications_outlined, AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, tint) = _iconFor(item);
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      onTap: item.isRead
          ? null
          : () => context
              .read<NotificationsBloc>()
              .add(NotificationsMarkReadRequested(item.id)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.labelLg.copyWith(
                    fontWeight:
                        item.isRead ? FontWeight.w500 : FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(_relative(context, item.createdAt), style: AppTextStyles.bodySm),
              ],
            ),
          ),
          if (!item.isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
