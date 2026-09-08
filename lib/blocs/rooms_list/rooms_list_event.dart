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

/// Fires when the admin submits the Add Room bottom sheet.
class RoomsListCreateRequested extends RoomsListEvent {
  const RoomsListCreateRequested({
    required this.name,
    this.status,
    this.supportedSpecialty,
  });

  final String name;
  final RoomStatus? status;
  final String? supportedSpecialty;

  @override
  List<Object?> get props => [name, status, supportedSpecialty];
}
