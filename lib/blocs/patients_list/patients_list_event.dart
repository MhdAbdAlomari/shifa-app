part of 'patients_list_bloc.dart';

sealed class PatientsListEvent extends Equatable {
  const PatientsListEvent();

  @override
  List<Object?> get props => const [];
}

class PatientsListRequested extends PatientsListEvent {
  const PatientsListRequested();
}

class PatientsListRefreshRequested extends PatientsListEvent {
  const PatientsListRefreshRequested();
}

class PatientsListSearchChanged extends PatientsListEvent {
  const PatientsListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class PatientsListDeleteRequested extends PatientsListEvent {
  const PatientsListDeleteRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class PatientsListCreateRequested extends PatientsListEvent {
  const PatientsListCreateRequested({
    required this.name,
    required this.mrn,
    this.medicalNotes,
  });

  final String name;
  final String mrn;
  final String? medicalNotes;

  @override
  List<Object?> get props => [name, mrn, medicalNotes];
}

class PatientsListUpdateRequested extends PatientsListEvent {
  const PatientsListUpdateRequested({
    required this.id,
    required this.name,
    required this.mrn,
    this.medicalNotes,
  });

  final int id;
  final String name;
  final String mrn;
  final String? medicalNotes;

  @override
  List<Object?> get props => [id, name, mrn, medicalNotes];
}
