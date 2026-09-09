import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/rooms_list/rooms_list_bloc.dart';
import '../../core/di.dart';
import '../../core/l10n/error_code_l10n.dart';
import '../../core/l10n/message_code.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/operating_room.dart';
import '../../data/models/room_status.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../widgets/app_bottom_nav_bar.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_header.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/filter_pills.dart';
import '../../widgets/loading_view.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/app_snack_bar.dart';

String _messageText(
  AppLocalizations l10n,
  MessageCode? code,
  String? error, [
  String? errorCode,
]) {
  if (code != null) {
    return switch (code) {
      MessageCode.roomDeleted => l10n.messageRoomDeleted,
      MessageCode.roomAdded => l10n.messageRoomAdded,
      MessageCode.roomUpdated => l10n.messageRoomUpdated,
      MessageCode.staffDeleted => l10n.messageStaffDeleted,
      MessageCode.staffAdded => l10n.messageStaffAdded,
      MessageCode.surgeryStarted => l10n.messageSurgeryStarted,
      MessageCode.surgeryCancelled => l10n.messageSurgeryCancelled,
      _ => localizedErrorMessage(l10n, code: errorCode, fallback: error ?? ''),
    };
  }
  return localizedErrorMessage(l10n, code: errorCode, fallback: error ?? '');
}

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

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppHeader(subtitle: l10n.subtitleOrSchedule),
      bottomNavigationBar: AppBottomNavBar(
        role: user.role,
        currentRouteName: AppRoutes.adminRooms,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<RoomsListBloc, RoomsListState>(
          listenWhen: (p, c) =>
              (p.actionMessageCode != c.actionMessageCode ||
                  p.actionErrorMessage != c.actionErrorMessage) &&
              (c.actionMessageCode != null || c.actionErrorMessage != null),
          listener: (context, state) {
            final message = _messageText(
              l10n,
              state.actionMessageCode,
              state.actionErrorMessage,
              state.actionErrorCode,
            );
            if (state.actionErrorMessage != null) {
              showErrorSnackBar(context, message);
            } else {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          },
          builder: (context, state) {
            return switch (state.status) {
              RoomsListStatus.initial ||
              RoomsListStatus.loading =>
                state.rooms.isEmpty ? const LoadingView() : _Body(state: state),
              RoomsListStatus.error => ErrorView(
                  message: localizedErrorMessage(
                    l10n,
                    code: state.errorCode,
                    fallback: state.errorMessage ?? l10n.roomsListFailedToLoad,
                  ),
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
    final l10n = AppLocalizations.of(context);
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
                        l10n.roomsListTitle,
                        style: AppTextStyles.headlineMd
                            .copyWith(color: AppColors.primary),
                      ),
                      Text(
                        l10n.roomsListSuitesConfigured(state.rooms.length),
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
                label: l10n.roomsListFilterAll(
                  state.countOf(RoomsListFilter.all),
                ),
                value: RoomsListFilter.all,
              ),
              FilterOption(
                label: l10n.roomsListFilterInUse(
                  state.countOf(RoomsListFilter.inUse),
                ),
                value: RoomsListFilter.inUse,
              ),
              FilterOption(
                label: l10n.roomsListFilterFree(
                  state.countOf(RoomsListFilter.free),
                ),
                value: RoomsListFilter.free,
              ),
              FilterOption(
                label: l10n.roomsListFilterPreparing(
                  state.countOf(RoomsListFilter.preparing),
                ),
                value: RoomsListFilter.preparing,
              ),
              FilterOption(
                label: l10n.roomsListFilterCleaning(
                  state.countOf(RoomsListFilter.cleaning),
                ),
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
                    children: [
                      const SizedBox(height: 80),
                      EmptyView(
                        icon: Icons.meeting_room_outlined,
                        title: l10n.roomsListNoMatchTitle,
                        subtitle: l10n.roomsListNoMatchSubtitle,
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
            label: l10n.roomsListAddRoom,
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
        imageBytes: draft.imageBytes,
        imageFilename: draft.imageFilename,
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
      onTap: () => context.pushNamed(
        AppRoutes.roomDetail,
        pathParameters: {'id': '${room.id}'},
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            child: room.imageUrl != null
                ? Image.network(
                    room.imageUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _RoomAvatar(room: room),
                  )
                : _RoomAvatar(room: room),
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
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _openEditSheet(context),
          ),
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

  Future<void> _openEditSheet(BuildContext context) async {
    final bloc = context.read<RoomsListBloc>();
    final draft = await showModalBottomSheet<_RoomDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _AddRoomSheet(existing: room),
    );
    if (draft != null) {
      bloc.add(RoomsListUpdateRequested(
        id: room.id,
        name: draft.name,
        status: draft.status,
        supportedSpecialty: draft.supportedSpecialty,
        imageBytes: draft.imageBytes,
        imageFilename: draft.imageFilename,
      ));
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.roomsListDeleteTitle(room.name)),
        content: Text(l10n.roomsListDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<RoomsListBloc>().add(RoomsListDeleteRequested(room.id));
    }
  }
}

class _RoomAvatar extends StatelessWidget {
  const _RoomAvatar({required this.room});

  final OperatingRoom room;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        style: AppTextStyles.titleMd.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _ImagePickerPlaceholder extends StatelessWidget {
  const _ImagePickerPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      color: AppColors.softHover,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_a_photo_outlined, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.xxs),
          Text(label, style: AppTextStyles.bodySm),
        ],
      ),
    );
  }
}

class _RoomDraft {
  const _RoomDraft({
    required this.name,
    required this.status,
    required this.supportedSpecialty,
    this.imageBytes,
    this.imageFilename,
  });
  final String name;
  final RoomStatus? status;
  final String? supportedSpecialty;
  final Uint8List? imageBytes;
  final String? imageFilename;
}

/// Add/Edit Room form. Pass [existing] to pre-fill and switch to edit
/// mode; omit it for a fresh Add Room flow. Image picking uses
/// `image_picker`'s cross-platform `pickImage`, which works on web via
/// a native file-picker dialog — no platform-specific code needed.
class _AddRoomSheet extends StatefulWidget {
  const _AddRoomSheet({this.existing});

  final OperatingRoom? existing;

  @override
  State<_AddRoomSheet> createState() => _AddRoomSheetState();
}

class _AddRoomSheetState extends State<_AddRoomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late final _specialtyController =
      TextEditingController(text: widget.existing?.supportedSpecialty ?? '');
  late RoomStatus _status = widget.existing?.status ?? RoomStatus.free;
  Uint8List? _pickedImageBytes;
  String? _pickedImageFilename;

  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _pickedImageBytes = bytes;
      _pickedImageFilename = picked.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final existingImageUrl = widget.existing?.imageUrl;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenEdge,
        right: AppSpacing.screenEdge,
        top: AppSpacing.xs,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEditing
                  ? l10n.roomsListEditSheetTitle
                  : l10n.roomsListAddSheetTitle,
              style: AppTextStyles.headlineMd,
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                child: _pickedImageBytes != null
                    ? Image.memory(
                        _pickedImageBytes!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : existingImageUrl != null
                        ? Image.network(
                            existingImageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _ImagePickerPlaceholder(
                              label: l10n.roomDetailChangePhoto,
                            ),
                          )
                        : _ImagePickerPlaceholder(
                            label: l10n.roomDetailAddPhoto,
                          ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.roomsListNameLabel),
              validator: (v) => v == null || v.trim().isEmpty
                  ? l10n.roomsListNameRequired
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _specialtyController,
              decoration: InputDecoration(
                labelText: l10n.roomsListSpecialtyLabel,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<RoomStatus>(
              initialValue: _status,
              decoration:
                  InputDecoration(labelText: l10n.roomsListInitialStatusLabel),
              items: [
                DropdownMenuItem(
                  value: RoomStatus.free,
                  child: Text(l10n.roomsListStatusFree),
                ),
                DropdownMenuItem(
                  value: RoomStatus.preparing,
                  child: Text(l10n.roomsListStatusPreparing),
                ),
                DropdownMenuItem(
                  value: RoomStatus.inUse,
                  child: Text(l10n.roomsListStatusInUse),
                ),
                DropdownMenuItem(
                  value: RoomStatus.cleaning,
                  child: Text(l10n.roomsListStatusCleaning),
                ),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: _isEditing ? l10n.commonSave : l10n.roomsListAddRoom,
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                final specialty = _specialtyController.text.trim();
                Navigator.of(context).pop(_RoomDraft(
                  name: _nameController.text.trim(),
                  status: _status,
                  supportedSpecialty:
                      specialty.isEmpty ? null : specialty,
                  imageBytes: _pickedImageBytes,
                  imageFilename: _pickedImageFilename,
                ));
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
