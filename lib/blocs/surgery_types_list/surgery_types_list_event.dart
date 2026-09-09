part of 'surgery_types_list_bloc.dart';

sealed class SurgeryTypesListEvent extends Equatable {
  const SurgeryTypesListEvent();

  @override
  List<Object?> get props => const [];
}

class SurgeryTypesListRequested extends SurgeryTypesListEvent {
  const SurgeryTypesListRequested();
}

class SurgeryTypesListRefreshRequested extends SurgeryTypesListEvent {
  const SurgeryTypesListRefreshRequested();
}

class SurgeryTypesListDeleteRequested extends SurgeryTypesListEvent {
  const SurgeryTypesListDeleteRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class SurgeryTypesListCreateRequested extends SurgeryTypesListEvent {
  const SurgeryTypesListCreateRequested({
    required this.name,
    required this.averageDurationMin,
    this.requiredSpecialty,
    this.defaultRoomId,
  });

  final String name;
  final int averageDurationMin;
  final String? requiredSpecialty;
  final int? defaultRoomId;

  @override
  List<Object?> get props =>
      [name, averageDurationMin, requiredSpecialty, defaultRoomId];
}

class SurgeryTypesListUpdateRequested extends SurgeryTypesListEvent {
  const SurgeryTypesListUpdateRequested({
    required this.id,
    required this.name,
    required this.averageDurationMin,
    this.requiredSpecialty,
    this.defaultRoomId,
  });

  final int id;
  final String name;
  final int averageDurationMin;
  final String? requiredSpecialty;
  final int? defaultRoomId;

  @override
  List<Object?> get props =>
      [id, name, averageDurationMin, requiredSpecialty, defaultRoomId];
}
