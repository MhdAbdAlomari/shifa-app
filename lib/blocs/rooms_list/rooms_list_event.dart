part of 'rooms_list_bloc.dart';

sealed class RoomsListEvent extends Equatable {
  const RoomsListEvent();

  @override
  List<Object?> get props => const [];
}

class RoomsListRequested extends RoomsListEvent {
  const RoomsListRequested();
}

class RoomsListRefreshRequested extends RoomsListEvent {
  const RoomsListRefreshRequested();
}

class RoomsListFilterChanged extends RoomsListEvent {
  const RoomsListFilterChanged(this.filter);

  final RoomsListFilter filter;

  @override
  List<Object?> get props => [filter];
}

class RoomsListDeleteRequested extends RoomsListEvent {
  const RoomsListDeleteRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

/// Fires when the admin/coordinator submits the Add Room bottom sheet.
class RoomsListCreateRequested extends RoomsListEvent {
  const RoomsListCreateRequested({
    required this.name,
    this.status,
    this.supportedSpecialty,
    this.imageBytes,
    this.imageFilename,
  });

  final String name;
  final RoomStatus? status;
  final String? supportedSpecialty;
  final List<int>? imageBytes;
  final String? imageFilename;

  @override
  List<Object?> get props =>
      [name, status, supportedSpecialty, imageBytes, imageFilename];
}

/// Fires when the admin/coordinator submits the Edit Room bottom sheet.
class RoomsListUpdateRequested extends RoomsListEvent {
  const RoomsListUpdateRequested({
    required this.id,
    required this.name,
    this.status,
    this.supportedSpecialty,
    this.imageBytes,
    this.imageFilename,
  });

  final int id;
  final String name;
  final RoomStatus? status;
  final String? supportedSpecialty;
  final List<int>? imageBytes;
  final String? imageFilename;

  @override
  List<Object?> get props =>
      [id, name, status, supportedSpecialty, imageBytes, imageFilename];
}
