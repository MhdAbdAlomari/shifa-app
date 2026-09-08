import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/rooms_list/rooms_list_bloc.dart';
import '../../core/di.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/room_status.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/filter_pills.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';

class RoomsListScreen extends StatelessWidget {
  const RoomsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomsListBloc(
        roomService: context.read<AppContainer>().roomService,
      )..add(const RoomsListRequested()),
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

    return Scaffold(
      appBar: const AppHeader(subtitle: 'Or Schedule'),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.adminRooms,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<RoomsListBloc, RoomsListState>(
          listenWhen: (p, c) =>
              p.actionMessage != c.actionMessage && c.actionMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          },
          builder: (context, state) {
            return switch (state.status) {
              RoomsListStatus.initial ||
              RoomsListStatus.loading =>
                state.rooms.isEmpty ? const LoadingView() : _Body(state: state),
              RoomsListStatus.error => ErrorView(
                  message: state.errorMessage ?? 'Failed to load rooms',
                  onRetry: () => context
                      .read<RoomsListBloc>()
                      .add(const RoomsListRequested()),
                ),
              RoomsListStatus.loaded => _Body(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state});

  final RoomsListState state;

  @override
  Widget build(BuildContext context) {
    final visible = state.visibleRooms;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenEdge,
            AppSpacing.md,
            AppSpacing.screenEdge,
            AppSpacing.xs,
          ),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Operating Rooms',
                        style: AppTextStyles.headlineMd
                            .copyWith(color: AppColors.primary),
                      ),
                      Text(
                        '${state.rooms.length} Operating Suite${state.rooms.length == 1 ? '' : 's'} Configured',
                        style: AppTextStyles.bodySm,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.softHover,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: const Icon(
                    Icons.meeting_room_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: FilterPills<RoomsListFilter>(
            options: [
              FilterOption(
                label: 'All Suites (${state.countOf(RoomsListFilter.all)})',
                value: RoomsListFilter.all,
              ),
              FilterOption(
                label: 'In use (${state.countOf(RoomsListFilter.inUse)})',
                value: RoomsListFilter.inUse,
              ),
              FilterOption(
                label: 'Free (${state.countOf(RoomsListFilter.free)})',
                value: RoomsListFilter.free,
              ),
              FilterOption(
                label:
                    'Preparing (${state.countOf(RoomsListFilter.preparing)})',
                value: RoomsListFilter.preparing,
              ),
              FilterOption(
                label:
                    'Cleaning (${state.countOf(RoomsListFilter.cleaning)})',
                value: RoomsListFilter.cleaning,
              ),
            ],
            selected: state.filter,
            onChanged: (v) => context
                .read<RoomsListBloc>()
                .add(RoomsListFilterChanged(v)),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => context
                .read<RoomsListBloc>()
                .add(const RoomsListRefreshRequested()),
            child: visible.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.meeting_room_outlined,
                        title: 'No matching rooms',
                        subtitle: 'Try a different filter.',
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screenEdge),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => _RoomRow(
                      room: visible[i],
                      isDeleting: state.deletingId == visible[i].id,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenEdge),
          child: PrimaryButton(
            label: 'Add Room',
            icon: Icons.add,
            isLoading: state.creating,
            onPressed: () => _openAddSheet(context),
          ),
        ),
      ],
    );
  }

  Future<void> _openAddSheet(BuildContext context) async {
    final bloc = context.read<RoomsListBloc>();
    final draft = await showModalBottomSheet<_RoomDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AddRoomSheet(),
    );
    if (draft != null) {
      bloc.add(RoomsListCreateRequested(
        name: draft.name,
        status: draft.status,
        supportedSpecialty: draft.supportedSpecialty,
      ));
    }
  }
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.room, required this.isDeleting});

  final OperatingRoom room;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.statusFreeBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.statusFreeBorder),
            ),
            alignment: Alignment.center,
            child: Text(
              room.id.toString().padLeft(2, '0'),
              style: AppTextStyles.titleMd
                  .copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.name, style: AppTextStyles.titleLg),
                if (room.supportedSpecialty != null)
                  Text(
                    room.supportedSpecialty!,
                    style: AppTextStyles.bodySm,
                  ),
              ],
            ),
          ),
          StatusBadge.room(room.status),
          IconButton(
            icon: isDeleting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.delete_outline),
            onPressed: isDeleting ? null : () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${room.name}?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<RoomsListBloc>().add(RoomsListDeleteRequested(room.id));
    }
  }
}

class _RoomDraft {
  const _RoomDraft({
    required this.name,
    required this.status,
    required this.supportedSpecialty,
  });
  final String name;
  final RoomStatus? status;
  final String? supportedSpecialty;
}

class _AddRoomSheet extends StatefulWidget {
  const _AddRoomSheet();

  @override
  State<_AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends State<_AddRoomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialtyController = TextEditingController();
  RoomStatus _status = RoomStatus.free;

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenEdge,
        right: AppSpacing.screenEdge,
        top: AppSpacing.xs,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add Operating Room', style: AppTextStyles.headlineMd),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: 'Name (e.g. OR-6)'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _specialtyController,
              decoration: const InputDecoration(
                labelText: 'Supported specialty (optional)',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<RoomStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Initial status'),
              items: const [
                DropdownMenuItem(value: RoomStatus.free, child: Text('Free')),
                DropdownMenuItem(
                  value: RoomStatus.preparing,
                  child: Text('Preparing'),
                ),
                DropdownMenuItem(
                  value: RoomStatus.inUse,
                  child: Text('In use'),
                ),
                DropdownMenuItem(
                  value: RoomStatus.cleaning,
                  child: Text('Cleaning'),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Add room',
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final specialty = _specialtyController.text.trim();
                Navigator.of(context).pop(_RoomDraft(
                  name: _nameController.text.trim(),
                  status: _status,
                  supportedSpecialty:
                      specialty.isEmpty ? null : specialty,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
