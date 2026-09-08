part of 'staff_list_bloc.dart';

sealed class StaffListEvent extends Equatable {
  const StaffListEvent();

  @override
  List<Object?> get props => const [];
}

class StaffListRequested extends StaffListEvent {
  const StaffListRequested();
}

class StaffListRefreshRequested extends StaffListEvent {
  const StaffListRefreshRequested();
}

class StaffListSearchChanged extends StaffListEvent {
  const StaffListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class StaffListFilterChanged extends StaffListEvent {
  const StaffListFilterChanged(this.filter);

  final StaffListFilter filter;

  @override
  List<Object?> get props => [filter];
}

class StaffListDeleteRequested extends StaffListEvent {
  const StaffListDeleteRequested(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class StaffListCreateRequested extends StaffListEvent {
  const StaffListCreateRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.specialty,
  });

  final String name;
  final String email;
  final String password;
  final UserRole role;
  final String? specialty;

  @override
  List<Object?> get props => [name, email, password, role, specialty];
}
